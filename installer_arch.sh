#!/bin/bash
################################################################################
################################################################################
# Name:        installer_arch.sh
# Description: Installs required packages on a Arch system to build the 
#              rhcsa8env environment
# Created:     2020-12-17
# Author:      Victor Mendonca - http://victormendonca.com
#                              - https://github.com/victorbrca
################################################################################
################################################################################

#-------------------------------------------------------------------------------
# Pre Setup
#-------------------------------------------------------------------------------

Color_Off='\e[0m'       # Text Reset
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green

# Get sudo prompt
sudo -v

# Set max screen size
tput_cols=$(tput cols)
if [ ! "$tput_cols" ] ; then
  echo "Could not define terminal size"
  exit 1
fi

if [[ $tput_cols -gt 70 ]] ; then
  max_char=70
else
  max_char="$(echo "$tput_cols - 5" | bc)"
fi

# Open file descriptor
exec 3>&1

#-------------------------------------------------------------------------------
# Define Functions
#-------------------------------------------------------------------------------

_closeDescriptor ()
{
  exec 3>&-
}

spinner ()
{
  local -r pid="${1}" delay="${2-.5}"
  local -r spinchars=( '|' '/' '-' '\' )
  local s=0
  printf "[${spinchars[${s}]}]" >&3
  while kill -0 ${pid} &> /dev/null ; do
    sleep ${delay}
    printf "\b\b${spinchars[$((++s%4))]}]" >&3
  done
  printf '\b\b\b' >&3
}

_checkExit ()
{
  if wait $pid ; then
    echo -e "${Green}ok ${Color_Off}" >&3
  else
    echo -e "${Red}Failed ${Color_Off}" >&3
    _closeDescriptor
    exit 1
  fi
}

_updatePacman ()
{
  local mesg char_cnt fill

  mesg="Updating pacman"
  char_cnt=$(echo "$max_char - $(echo "$mesg" | wc -c)" | bc)
  fill="$(printf '%0.s-' $(seq 1 $char_cnt))"
  sudo /usr/bin/pacman -Sy &> /dev/null &
  pid=$!
  echo -e "$mesg $fill \c" >&3
  spinner $pid
  _checkExit
}

_installBaseDevel ()
{
  local mesg char_cnt fill

  mesg="Installing base devel"
  char_cnt=$(echo "$max_char - $(echo "$mesg" | wc -c)" | bc)
  fill="$(printf '%0.s-' $(seq 1 $char_cnt))"
  sudo /usr/bin/pacman -S --noconfirm --needed base-devel &> /dev/null &
  pid=$!
  echo -e "$mesg $fill \c" >&3
  spinner $pid
  _checkExit
}

_installPackages ()
{
  local mesg char_cnt fill

  mesg="Installing needed packages"
  char_cnt=$(echo "$max_char - $(echo "$mesg" | wc -c)" | bc)
  fill="$(printf '%0.s-' $(seq 1 $char_cnt))"
  yes | sudo /usr/bin/pacman -S --needed \
   ansible \
   virtualbox \
   virtualbox-host-modules-arch \
   virtualbox-guest-iso \
   vagrant \
   libvirt &> /dev/null &
  pid=$!
  echo -e "$mesg $fill \c" >&3
  spinner $pid
  _checkExit
}

_installVagrantPlugin ()
{
  local mesg char_cnt fill

  mesg="Installing Vagrant ansible plugin"
  char_cnt=$(echo "$max_char - $(echo "$mesg" | wc -c)" | bc)
  fill="$(printf '%0.s-' $(seq 1 $char_cnt))"
  vagrant plugin install vagrant-guest_ansible &> /dev/null &
  pid=$!
  echo -e "$mesg $fill \c" >&3
  spinner $pid
  _checkExit
}

_cloneRepo ()
{
  local mesg char_cnt fill

  mesg="Cloning the Git repo"
  char_cnt=$(echo "$max_char - $(echo "$mesg" | wc -c)" | bc)
  fill="$(printf '%0.s-' $(seq 1 $char_cnt))"
  cd "${HOME}/Downloads"
  git clone https://github.com/rdbreak/rhcsa8env &> /dev/null &
  pid=$!
  echo -e "$mesg $fill \c" >&3
  spinner $pid
  _checkExit
}

#-------------------------------------------------------------------------------
# Start tasks
#-------------------------------------------------------------------------------

clear
echo -e "\n## Starting setup for rhcsa8env lab\n"
_updatePacman
_installBaseDevel
_installPackages
_installVagrantPlugin

# Create a download folder
mkdir -p "${HOME}/Downloads"
if [ ! -d "${HOME}/Downloads" ] ; then
  echo "Failed. Could not create \"${HOME}/Downloads\""
  _closeDescriptor
  exit 1
fi

# Clones the Git Repo
_cloneRepo

# Closes descriptor
_closeDescriptor

# Check that the folder was created
if [ ! -d rhcsa8env ] ; then
  echo "Failed. Could not create clone the Git repo"
  exit 1
fi

# Change into the folder
cd rhcsa8env &> /dev/null

# Prompt to build environment
echo -e "\nYour environment is ready to be built. Would you like to start?"
read -p "[y|n]: " answer

if [ ! "$answer" ] ; then
  exit 1
fi

case $answer in
  y|Y|yes|YES|Yes) : ;;
  n|N|no|NO|No) exit 0 ;;
  *)
    echo "Wrong option"
    exit 1
    ;;
esac

vagrant up

