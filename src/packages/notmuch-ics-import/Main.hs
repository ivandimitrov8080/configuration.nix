{-# LANGUAGE OverloadedStrings #-}

-- | Minimal notmuch @post-new@ hook: import ICS attachments from freshly
-- delivered messages into khal.
--
-- Built and wired up via @programs.notmuch.hooks.postNew@ in
-- @src/modules/home-manager/accounts.nix@, which compiles this file with GHC
-- and guarantees @notmuch@ and @khal@ are on PATH.
module Main (main) where

import Codec.MIME.Parse (parseMIMEMessage)
import Codec.MIME.Type (DispParam (Filename), Disposition (..), MIMEContent (..), MIMEType (..), MIMEValue (..), Type (..))
import Control.Exception (IOException, SomeException, bracket_, catch, try)
import Control.Monad (unless)
import Control.Monad.Except (runExceptT)
import qualified Data.ByteString as B
import Data.List (nub)
import Data.Maybe (listToMaybe, mapMaybe)
import qualified Data.Text as T
import Data.Text.Encoding (decodeUtf8With, encodeUtf8)
import Data.Text.Encoding.Error (lenientDecode)
import Notmuch (SearchTerm (Tag), Status, databaseOpenReadOnly, messageFilename, messages, query)
import System.Directory (getTemporaryDirectory, removeFile)
import System.Exit (ExitCode (ExitSuccess), exitFailure, exitSuccess)
import System.Process (callProcess, readProcessWithExitCode)

main :: IO ()
main = do
  db <- notmuchDatabasePath
  found <- runExceptT (databaseOpenReadOnly db >>= \d -> query d (Tag "new") >>= messages)
  paths <- case found of
    Left e -> die ("cannot read " ++ db ++ ": " ++ show (e :: Status))
    Right ms -> mapM messageFilename ms
  msgs <- mapM readIfExists paths
  let ics = nub (concatMap (calendarParts . parseMIMEMessage . decode) (mapMaybe id msgs))
  unless (null ics) (importIcs (map encodeUtf8 ics))
  exitSuccess

die :: String -> IO a
die msg = putStrLn ("notmuch-ics-import: " ++ msg) >> exitFailure

-- | The database directory, as configured for the @notmuch@ on PATH.  The
-- library takes a path rather than reading @notmuch@'s configuration itself.
notmuchDatabasePath :: IO FilePath
notmuchDatabasePath = do
  (st, out, err) <- readProcessWithExitCode "notmuch" ["config", "get", "database.path"] ""
  case (st, lines out) of
    (ExitSuccess, p : _) | not (null p) -> pure p
    _ -> die ("cannot determine database.path: " ++ err)

-- | Read a message, tolerating paths that vanished since the search.
readIfExists :: FilePath -> IO (Maybe B.ByteString)
readIfExists p = (Just <$> B.readFile p) `catch` \(_ :: IOException) -> pure Nothing

decode :: B.ByteString -> T.Text
decode = decodeUtf8With lenientDecode

-- | Every calendar part of a message, transfer-decoded, recursing into the
-- multipart structure.
calendarParts :: MIMEValue -> [T.Text]
calendarParts v = case mime_val_content v of
  Multi vs -> concatMap calendarParts vs
  Single c | isCalendar v -> [c]
  _ -> []

isCalendar :: MIMEValue -> Bool
isCalendar v = isCalendarType (mime_val_type v) || maybe False (T.isSuffixOf ".ics" . T.toLower) (filename v)

isCalendarType :: Type -> Bool
isCalendarType (Type (Text "calendar") _) = True
isCalendarType (Type (Other "application" "ics") _) = True
isCalendarType _ = False

-- | The @filename=@ parameter of a part's @Content-Disposition@.
filename :: MIMEValue -> Maybe T.Text
filename v = case mime_val_disp v of
  Just (Disposition _ ps) -> listToMaybe [t | Filename t <- ps]
  Nothing -> Nothing

-- | Hand every extracted calendar object over to khal, always cleaning up.
importIcs :: [B.ByteString] -> IO ()
importIcs ics = do
  dir <- getTemporaryDirectory
  let paths = [dir ++ "/notmuch-invite-" ++ show n ++ ".ics" | n <- [1 :: Int .. length ics]]
  bracket_
    (mapM_ (uncurry B.writeFile) (zip paths ics))
    (mapM_ removeFile paths)
    (try (callProcess "khal" (["import", "--batch"] ++ paths)) >>= report)
  where
    report (Right ()) = pure ()
    report (Left e) = putStrLn ("notmuch-ics-import: khal import failed: " ++ show (e :: SomeException))
