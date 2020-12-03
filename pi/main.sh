#!/bin/bash

user=$( dialog --stdout --menu 'selecione a ação quendeseja realizar:' 0 0 0 1 'secgroup' 2 'tcpdump' 3 'iptables' )

if [ $user -eq 1 ] 
then
 exec /home/ubuntu/pi/secu/secu.sh
elif [ $user -eq 2 ] 
then
 exec /home/ubuntu/pi/tcpdump/tcpdump_dialog.sh
elif [ $user -eq 3 ] 
then
 exec /home/ubuntu/pi/iptab/Dialog.sh
fi