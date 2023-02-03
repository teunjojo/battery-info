#!/bin/bash
version=1.6

lib="libteunjojo"
[ ! -f "$lib.sh" ] && curl -s -o $lib.sh https://files.teunjojo.com/$lib/latest/$lib.sh && chmod +x $lib.sh
source $lib.sh

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
dir=$dir$(cd $dir && ls | grep 'BAT/')
[[ ! -d $dir || ! -f $dir/charge_full || ! -f $dir/charge_full_design || ! -f $dir/charge_now || ! -f $dir/status ]] && echo "Device not supported!" && exit

charge_full=$(cat "$dir/charge_full")
charge_full_design=$(cat "$dir/charge_full_design")
charge_now=$(cat "$dir/charge_now")
percentage=$(awk -vn="$charge_now" -vm="$(awk -vn="$charge_full" 'BEGIN{print(n/100)}')" 'BEGIN{printf("%.0f\n",n/m)}')
[[ $percentage -gt 100 ]] && percentage=100
capacity=$(awk -vn="$charge_now" -vm="$(awk -vn="$charge_full_design" 'BEGIN{print(n/100)}')" 'BEGIN{printf("%.0f\n",n/m)}')
status=$(cat "$dir/status")

while :; do
    case "${1-}" in
    -h | --help) usage
    exit ;;
    -v | --version) output="$0 v$version";;
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
[[ ! $output ]] && usage || echo "$output"
