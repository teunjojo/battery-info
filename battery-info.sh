#!/bin/bash

usage()
{
cat << EOF
usage: $0 [OPTION]

This script shows the battery percentage.

OPTIONS:

    -p             Show battery percentage
    -P             Show battery percentage with percentage symbol
    -c             Show battery capacity/health
    -C             Show battery capacity/health with percentage symbol
    -s             Shows charging state
    -v, --version  Show version number of $0
    -h, --help     Show this message
EOF
}

dir="/sys/class/power_supply/"
dir=$dir$(cd $dir && ls | grep 'BAT')
[[ ! -d $dir ]] && die "Required directory not found!"

charge_full=$(cat $dir/charge_full)
charge_full_design=$(cat $dir/charge_full_design)
charge_now=$(cat $dir/charge_now)
percentage=$(awk -vn="$charge_now" -vm="$(awk -vn="$charge_full" 'BEGIN{print(n/100)}')" 'BEGIN{printf("%.0f\n",n/m)}')
[[ $percentage -gt 100 ]] && percentage=100
capacity=$(awk -vn="$charge_now" -vm="$(awk -vn="$charge_full_design" 'BEGIN{print(n/100)}')" 'BEGIN{printf("%.0f\n",n/m)}')
status=$(cat $dir/status)
version="$0 v1.1"

while :; do
    case "${1-}" in
    -h | --help) usage
    exit ;;
    -v | --version) output=$version;;
    -p) output=$percentage ;;
    -c) output=$capacity ;;
    -P) output=$percentage% ;;
    -C) output=$capacity% ;;
    -s) output=$status ;;
    -?*) echo "Unknown option: $1">&2 ;;
    *) break ;;
    esac
    shift
  done
[[ ! $output ]] && usage || echo $output
