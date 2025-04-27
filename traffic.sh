#!/bin/bash

VIC=victim.sanogo.de
USER=martha
PASS=mustang

f_ping()
{
   ping -c 5 $1 > /dev/null 2>&1
}
f_sendmail()
{
  {
    sleep 1
    echo "EHLO attacker"
    sleep 1
    echo "AUTH LOGIN"
    sleep 1
    echo -n "$USER" | base64 | tr -d '\n'
    echo
    sleep 1
    echo -n "$PASS" | base64 | tr -d '\n'
    echo
    sleep 1
    echo "MAIL FROM:<hacker@$VIC>"
    sleep 1
    echo "RCPT TO:<root@$VIC>"
    sleep 1
    echo "DATA"
    sleep 1
    echo "Subject: Ping success!"
    echo
    echo "Victim $VIC is reachable."
    echo "."
    sleep 1
    echo "QUIT"
  } | nc $VIC 25
}


while true
do
  sleep 3
  if f_ping $VIC
  then
    echo "$(date) - $VIC erreichbar, sende Mail"
    f_sendmail
  else
    echo "$(date) - $VIC NICHT erreichbar"
  fi
done

