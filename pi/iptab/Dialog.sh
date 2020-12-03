#!/bin/bash

echo "*filter
# Accept already connected sessions
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 
# Accept all loopback 
-A INPUT -i lo -j ACCEPT
 
# Open https/http port from anywhere
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
 
# Accept ssh port from anywhere
# -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
COMMIT" > /etc/sysconfig/iptables

sudo chkconfig iptables on
sudo service iptables start

    choice=$(dialog --menu "Que tipo de regra quer adicionar" 12 35 15 \
    1 "Aceitar" \
    2 "Rejeitar" --stdout)

    if [ $choice == 1 ]
    then
        choiceb=$(dialog --menu "Escolha uma regra" 12 35 15 \
        1 "Porta" \
        2 "IP"\
        3 "IP e porta" --stdout)
        echo $choiceb

        if [ $choiceb == 1 ]
        then
        porta=$(dialog --stdout --inputbox 'Digite a porta que deseja configuar:' 0 0 )
        sudo iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport $porta -j ACCEPT
        fi

        if [ $choiceb == 2 ]
        then
        ip=$(dialog --stdout --inputbox 'Digite o IP que deseja configuar:' 0 0 )
        sudo iptables -A INPUT -m state --state NEW -s $ip -j ACCEPT
        fi

        if [ $choiceb == 3 ]
        then
        porta=$(dialog --stdout --inputbox 'Digite a porta que deseja configuar:' 0 0 )
        ip=$(dialog --stdout --inputbox 'Digite o IP que deseja configuar:' 0 0 )
        sudo iptables -A INPUT -m state --state NEW -m tcp -p tcp -s $ip --dport $porta -j ACCEPT
        fi
        
    fi
    

    if [ $choice == 2 ]
    then
        choiceb=$(dialog --menu  20 35 15 \
        1 "Porta" \
        2 "IP"\
        3 "IP e porta" --stdout)

        if [ $choiceb == 1 ]
        then
        porta=$(dialog --stdout --inputbox 'Digite a porta que deseja configuar:' 0 0 )
        sudo iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport $porta -j DROP
        fi

        if [ $choiceb == 2 ]
        then
        ip=$(dialog --stdout --inputbox 'Digite o IP que deseja configuar:' 0 0 )
        sudo iptables -A INPUT -m state --state NEW -s $ip -j DROP
        fi

        if [ $choiceb == 3 ]
        then
        porta=$(dialog --stdout --inputbox 'Digite a porta que deseja configuar:' 0 0 )
        ip=$(dialog --stdout --inputbox 'Digite o IP que deseja configuar:' 0 0 )
        sudo iptables -A INPUT -m state --state NEW -m tcp -p tcp -s $ip --dport $porta -j DROP
        fi
        
    fi
