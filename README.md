# Ubuntu 20.04 LTS on DELL XPS 9310 Driver Configuration

The purpose of this script is to configure some of the proprietary hardware 
device drivers used in Dell XPS range (9305, 9310 etc).

This includes 
- Fingerprint scanner
- Howdy face recognition
- Power management tweaks 

## Installation

Run the below command in your bash shell

    curl -fsSL https://raw.githubusercontent.com/purinda/Ubuntu-DELL-XPS-9310-Configuration/master/install.sh -o install.sh && \
    chmod +x ./install.sh && \
    sudo ./install.sh
