#!/usr/bin/env bash

ss_dir="$(xdg-user-dir PICTURES)/ss"
pic_dir="$ss_dir/$(date "+%Y-%m-%d_%H-%M-%S").png"

mkdir -p "$ss_dir"

[[ $1 == area ]] && grimshot savecopy area "$pic_dir"
[[ $1 == screen ]] && grimshot savecopy screen "$pic_dir"
[[ $1 == window ]] && grimshot savecopy active "$pic_dir"
