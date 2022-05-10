#!/bin/bash
set -e # Exit the script as soon as one of the commands failed

#Colours
redColour="\e[0;31m\033[1m"
endColour="\033[0m"

trap ctrl_c INT

function ctrl_c(){
    echo -e "${redColour}Saliendo.......${endColour}"
    exit 0
}

#Variables Keystore and Cloudwatch
AliasName=$1
MetricName=$2
FilePath=ValidTuya.jks #Path keystore file
Password=valid872 #Password keystore file
Namespace=Microservice-Cert-Expiration #cloudwatch Namespace
InstanceName=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AWSZone=us-east-1



calculate_expiration_date() {
    ExpirationDate=$(keytool -list -v -keystore $FilePath -storepass $Password -alias "$AliasName" | sed "/Extensions:/,/\*\*/d" | grep  "until" | sed 's/.*until: //' | sed 's/COT/-05/g' 2>/dev/null)
    CertExpirationDate=$(date -d "${ExpirationDate}" +%s)
    Today=$(date +%s)
    DaysUntil=$(((CertExpirationDate - Today) / (24*3600)))
    aws cloudwatch put-metric-data --metric-name="$MetricName" --namespace $Namespace --value $DaysUntil --dimensions InstanceId=$InstanceName --region $AWSZone
    echo -e "[+] Metrica generada en AWS Cloudwatch: ${redColour}"$MetricName"${endColour}"
}

#Main Funcion
#Check if user is root
if [ "$(id -u)" == "0" ]; then 
    echo "[+] Calculando fecha.."
    calculate_expiration_date;
else
    echo "[+] No soy root"
fi

