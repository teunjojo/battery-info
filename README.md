# battery-info
Shitty shell script that shows battery info like battery health, charging state and battery percentage

I never upload to github, but decided to upload something. Please leave feedback on how shitty it is or what I should add.

## usage
./battery-info.sh [OPTION]

OPTIONS:

    -p  Show battery percentage
    
    -P  Show battery percentage with percentage symbol
    
    -c  Show battery capacity/health
    
    -C  Show battery capacity/health with percentage symbol
    
    -s  Shows charging status
    
    -v  Show version number of ./battery-info.sh
    
    -h  Show this message
    
This script depends on [UPower](https://upower.freedesktop.org) which is most likely preinstalled.
