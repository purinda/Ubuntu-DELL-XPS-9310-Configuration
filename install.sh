#!/usr/bin/env bash
#
# Script is a mini version of https://github.com/jules-ch/Ubuntu20-Setup-XPS13/blob/master/setup.sh

set -e

# Get the Ubuntu version installed
DISTRO_VER=$(lsb_release -r -s)
LOGIN_USER=$(logname)
HOWDY_VIDEO="device_path=\/dev\/video0"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ "$DISTRO_VER" != "20.04" ]
    then echo "Your installed Ubuntu version is $DISTRO_VER, this script only works with 20.04 LTS."
    exit
fi 

# Ubuntu apt repos
sh -c 'cat > /etc/apt/sources.list.d/focal-dell.list << EOF
deb http://dell.archive.canonical.com/updates/ focal-dell public
# deb-src http://dell.archive.canonical.com/updates/ focal-dell public
deb http://dell.archive.canonical.com/updates/ focal-oem public
# deb-src http://dell.archive.canonical.com/updates/ focal-oem public
deb http://dell.archive.canonical.com/updates/ focal-somerville public
# deb-src http://dell.archive.canonical.com/updates/ focal-somerville public
deb http://dell.archive.canonical.com/updates/ focal-somerville-melisa public
# deb-src http://dell.archive.canonical.com/updates focal-somerville-melisa public
EOF'

# Face recognition and TLP
add-apt-repository ppa:boltgolt/howdy -y > /dev/null 2>&1
add-apt-repository ppa:linrunner/tlp -y > /dev/null 2>&1

set -x

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F9FDA6BED73CDC22
apt update -qq


# Install hardware device drivers for fingerprint and power management tools
apt install oem-somerville-melisa-meta libfprint-2-tod1-goodix oem-somerville-meta tlp tlp-config howdy -y

# Install Howdy for facial recognition
HOWDY_CONF="/usr/lib/security/howdy/config.ini"

while true; do
  read -p "Setup face recognition with Howdy (y/n)?" choice
  case "$choice" in 
    y|Y ) 
    echo "Configuring Howdy for '$LOGIN_USER'"

    # Configure video device
    sed -i "s/^.*\bdevice_path\b.*$/$HOWDY_VIDEO/" $HOWDY_CONF

    # Register your face
    howdy -U $LOGIN_USER add

    break;;

    n|N )
    echo "Skipping configuration of Howdy"; break;;
    * ) echo "invalid";;
  esac
done
