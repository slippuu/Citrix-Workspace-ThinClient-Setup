#!/bin/bash

# -------------
# - Unattended build/install of Citrix Workspace
# -- Citrix Workspace Version: 2402 (Use earlier version to avoid EULA acceptance)
# -- https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest12.html
# -- SHA256:
# -- .deb || 32aaaccc40a2fa22c16354150461dcae9cfbde5cc66fafe1ea7e33ee068c733f
# -------------

# TODO:
#   SHA256 checking

# Set the DEBIAN_FRONTEND to "noninteractive" to automate package install
export DEBIAN_FRONTEND="noninteractive"

# Sort user & paths before rooting
usrMain=${USER}
usrHome="/home/${usrMain}/"
usrTemp="${usrHome}tmp/"

# Obtain the version of Citrix Workspace to download
citrixVersion=`curl -s -L https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html#ctx-dl-eula-external | grep "<h1>Citrix " | awk '{print $4}'`

# Set up the variable for saving the file later
debFile="citrix_workspace_${citrixVersion}_arm64.deb"

# Obtain a valid download string for the arm64 deb file (icaclient_arm64.deb)
url1="https:"
url2=`curl -s -L https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html#ctx-dl-eula-external | grep deb? | grep -o 'rel="[^"]*"' | sed -n '2p' | sed 's/rel="//;s/"$//'`
url=`echo "$url1$url2"`

# Engage root user
su -

# Download the arm64.deb file
curl -s -o $usrTemp$debFile $url

# Check to make sure file has successfully downloaded
if [ -e "$usrTemp$debFile" ]; then
    debSize=$(du -k $HOME/tmp/$debFile | cut -f 1)
    echo "Downloaded $debFile (${debSize} kb)"
else
    echo "Citrix failed to download. Exiting."
    exit
fi

# Set up the automated install
debconf-set-selections <<< "icaclient app_protection/install_app_protection select yes"
debconf-show icaclient
# Actually install the file
apt install -f ./${usrTemp}${debFile}

# Exit the root shell
exit

# Clear DEBIAN_FRONTEND from earlier
export DEBIAN_FRONTEND=""

# Remove temp folder
rm -rf $usrTemp