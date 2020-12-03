#!/bin/bash

salvar_em_arquivo() {
  dialog --common-options --yesno 'Deseja salvar o resultado em arquivo?' 0 0
  NOME=""
  if [ $? = 0 ]
  then
   NOME=$(dialog --stdout --inputbox 'Digite o nome do arquivo para salvar ex: nome.txt' 0 0)
   echo $NOME 
   return 1
  fi
    
}

escolher_porta() {


  
  PORTA=$(dialog --stdout --inputbox "Escolha a porta de rede, padrão é eth0." 0 0)
  
 echo $PORTA 
}

PORTA="eth0"
# NOME=$( salvar_em_arquivo )
# PORTA=$( escolher_porta )
# echo $PORTA

while true
 do
    ESCOLHA=$(dialog --stdout --radiolist 'ESCOLHA A OPÇÃO DO TCPDUMP' \
        0 0 0   Item1 'Analisar x pacotes do dispositivo' on \
                Item2 'Analisar pacotes de determinado protocolo' off \
                Item3 'Analisar pacotes de determinada porta' off \
                Item4 'alterar porta a ser analisada (eth0 padrão)' off)

    
    if [ $? = 1 ]
    then
    break 
    fi


    if [ $ESCOLHA = "Item1" ]
    then
      X=$(dialog --stdout --inputbox 'Digite a quantidade de pacotes a serem analisados' 0 0)
        dialog --title "Pacotes" --msgbox "$(sudo tcpdump -c $X -i $PORTA)" 0 0
        NOME=$(dialog --stdout --inputbox 'Digite o nome do arquivo para salvar ex: nome.txt' 0 0)
        sudo tcpdump -c $X -i $PORTA > $NOME
    

    fi

    if [ $ESCOLHA = "Item2" ]
    then
        X=$(dialog --stdout --inputbox 'Digite o protocolo dos quais os pacotes seram analisados ex: tcp, udp' 0 0)
        dialog --title "Pacotes" --msgbox "$(sudo tcpdump -c 10 -i $PORTA $X)" 0 0

        NOME=$(dialog --stdout --inputbox 'Digite o nome do arquivo para salvar ex: nome.txt' 0 0)
        sudo  tcpdump -c 10 -i $PORTA $X > $NOME
    fi

    if [ $ESCOLHA = "Item3" ]
    then
        X=$(dialog --stdout --inputbox 'Digite as portas dos quais os pacotes seram analisados ex: 22, 443 ' 0 0)
        dialog --title "Pacotes" --msgbox "$(sudo tcpdump -c 10 -i $PORTA port $X)" 0 0

        NOME=$(dialog --stdout --inputbox 'Digite o nome do arquivo para salvar ex: nome.txt' 0 0)
        sudo tcpdump -c 10 -i $PORTA port $X > $NOME
    fi

    if [ $ESCOLHA = "Item4" ]
    then
        dialog --title "SUAS PORTAS" --msgbox "$(sudo tcpdump -D)" 0 0
        PORTA=$( escolher_porta )

    fi





done