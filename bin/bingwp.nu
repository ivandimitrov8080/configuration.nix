#!/usr/bin/env nu

let today = (date now | format date '%Y-%m-%d')
let bg_dir = (xdg-user-dir PICTURES) | path join "bg"
let today_img_file = $bg_dir | path join ([$today, ".png"] | str join)
let is_new = ((date now | format date "%H" | into int) >= 10)
mkdir $bg_dir

def exists [file: path] {
  return ($file | path exists)
}

def is_empty [file: path] {
  return ((exists $file) and ((ls $file | get size | first | into int) == 0))
}

def fetch [] {
  let img_url = (curl "https://www.bing.com/HPImageArchive.aspx?format=js&n=1" | from json).images.0.url
  let full_url = "https://bing.com" + $img_url
  curl $full_url --output $today_img_file
}

def cleanup [] {
  if (is_empty $today_img_file) {
    rm -rf $today_img_file
  }
}

cleanup

if $is_new and (not (exists $today_img_file)) {
  fetch
}

cleanup
