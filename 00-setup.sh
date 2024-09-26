#!/bin/bash

# -------------
# - Unattended build/install of Citrix Workspace
# -- Citrix Workspace Version: 2402 (Use earlier version to avoid EULA acceptance)
# -- https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest12.html
# -- SHA256:
# -- .deb || 32aaaccc40a2fa22c16354150461dcae9cfbde5cc66fafe1ea7e33ee068c733f
# -------------

# Create file structure required
mkdir $HOME/tmp