#!/bin/bash

gw4=$(nmcli device show eth0 | grep IP4.GATEWAY | awk '{print$2}')

if [[ ! "$gw4" ]] ; then
  notify-send "RHCSA Simulator" "Could not understand the server"
  exit 1
fi


if [[ $1 =~ rdp: ]] ; then
  port=${1#rdp://}

  case $port in
    33389) server=server2 ;;
    33390) server=server1 ;;
  esac

  xfreerdp /v:${gw4}:${port} +clipboard /t:${server}
fi