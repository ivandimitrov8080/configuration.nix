let db = ($env.XDG_CACHE_HOME + "/frecently/pass.db")
let pwds = (fd -C ($env.PASSWORD_STORE_DIR) -e gpg --format '{.}')
if not ($db | path exists) {
   mkdir (dirname $db)
   frecently bump $db ($pwds | lines | first)
}
let passwords = ($pwds | frecently view $db --augment)
let selection = ($passwords | rofi -dmenu -p 'sudo')
frecently bump $db $selection
pass $selection
