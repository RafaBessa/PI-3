#!/bin/bash

function auto_config(){
  # porcorre entre os grupos
for group_id in $group_ids
do

    # mostra nome do grupo
    echo -e "\033[34m\nModifying Group: ${group_id}\033[0m";

    # captura regras exixtentes de ip nos grupos
    ips=$(aws ec2 --profile=$profile describe-security-groups --filters Name=ip-permission.to-port,Values=$port Name=ip-permission.from-port,Values=$port Name=ip-permission.protocol,Values=tcp --group-ids $group_id --output text --query 'SecurityGroups[*].{IP:IpPermissions[?ToPort==`'$port'`].IpRanges}' | sed 's/IP	//g');

    # percorre os IPs
    for ip in $ips
    do
        echo -e "\033[31mRemoving IP: $ip\033[0m"

        # deleta qualquer regra de ip que tenha haver com  a  porta
        aws ec2 revoke-security-group-ingress --profile=$profile --group-id $group_id --protocol tcp --port $port --cidr $ip
    done

    # captura o IP publico atual
    myip=$(curl -s https://api.ipify.org);

    echo -e "\033[32mSetting Current IP: ${myip}\033[0m"

    # adiciona o ip publco atual com regra
    aws ec2 authorize-security-group-ingress --profile=$profile --protocol tcp --port $port --cidr ${myip}/32 --group-id $group_id

    # percorre IPs fixos
    for ip in $fixed_ips
    do
        echo -e "\033[32mSetting Fixed IP: ${ip}\033[0m"

        # adiciona regras de IP fixo 
        aws ec2 authorize-security-group-ingress --profile=$profile --protocol tcp --port $port --cidr ${ip} --group-id $group_id
    done

done
}



# Setup
# ===============================
#capturando nome do perfil                        \
profile=$(dialog --stdout --inputbox 'Digite um ou mais perfis que deseja configurar com uma barra de espaço separando cada:' 0 0 )

# Grupos, separadps por espaços
group_ids=$( dialog --stdout --inputbox 'Digite um ou mais IDs de grupos que deseja configurar com uma barra de espaço separando cada:' 0 0 )

# IPs fixos, separdaos por espaço

fixed_ips=$( dialog --stdout --inputbox 'Digite um ou mais IPs fixos que deseja configurar com uma barra de espaço separando cada:' 0 0 )

# Porta
port=$( dialog --stdout --inputbox 'Digite a porta que deseja configuar:' 0 0 )
#=================================

dialog --msgbox "revise suas configurações: \n porta: "$port" \n ip(s):  "$fixed_ips"\n id(s):  "$group_ids"\n perfil(s): "$profile""  0 0

echo "revise suas configurações: "
echo "porta: $port" 
echo "ip(s):  $fixed_ips" 
echo "id(s):  $group_ids"
echo "perfil(s): $profile"
 
dialog --yesno 'deseja prosseguir?' 0 0


if [ $? -eq 0 ] 
then
auto_config

else
echo "script finalizado"
fi


