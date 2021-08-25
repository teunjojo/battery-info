p=$(upower -i $(upower -e | grep 'BAT') | grep -oP '(?<=percentage:).*[0-9]' | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
c=$(upower -i $(upower -e | grep 'BAT') | grep -oP '(?<=capacity:).*[0-9]' | sed 's/\./,/' | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
s=$(upower -i $(upower -e | grep 'BAT') | grep -oP '(?<=state:).*')
v="$0 v1.0"
usage()
{
cat << EOF

usage: $0 [OPTION]

This script shows the battery percentage.

OPTIONS:
    -p  Show battery percentage
    -P  Show battery percentage with percentage symbol
    -c  Show battery capacity/health
    -C  Show battery capacity/health with percentage symbol
    -s  Shows charging state
    -v  Show version number of $0
    -h  Show this message
EOF
}

while getopts ":pPcCsvh" OPTION; do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    p)
      output="$p"
      ;;
    P)
      output="$p%"
      ;;
    c)
      output="$c"
      ;;
    C)
      output="$c%"
      ;;
    s)
      output="$s"
      ;;
    v)
      output="$v"
      ;;
    ?)
      usage
      exit
      ;;
  esac
done
echo $output
