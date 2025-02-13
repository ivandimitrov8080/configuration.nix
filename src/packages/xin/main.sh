#!/usr/bin/env bash
usage() { echo "Usage: $0 [-p <nova|gaming|vps>]" 1>&2; exit 1; }
while getopts ":p:" o; do
    case "${o}" in
        p)
            profile=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${profile}" ]; then
    usage
fi

[[ $profile == "nova" ]] && sudo nixos-rebuild switch --profile-name "$profile" --flake "./#$profile"
[[ $profile == "vps" ]] && nixos-rebuild switch --flake "./#$profile" --target-host vpsfree-ivand --use-remote-sudo
