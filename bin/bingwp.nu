#!/usr/bin/env nu

let current_date = (date now | format date '%Y-%m-%d')
let bg_dir = (xdg-user-dir PICTURES) | path join "bg"
let img_file = $bg_dir | path join "$current_date.png"
mkdir $bg_dir

def isNew [] {
  if (date now | format date "%H" | into int) >= 10 and ($img_file | path exists) {
    true
  } else if ($img_file | ls | get size) == 0 {
    let img_file = $bg_dir | path join (bash -c 'date -d yesterday +%Y-%m-%d').png
    false
  } else {
    false
  }
}

def fetch [] {
  let img_url = (curl "https://www.bing.com/HPImageArchive.aspx?format=js&n=1" | from-json).images.0.url
  let full_url = "https://bing.com" + $img_url
  curl $full_url --output $img_file
}

if (isNew) {
  fetch
}

