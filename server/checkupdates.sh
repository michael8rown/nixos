#!/run/current-system/sw/bin/bash

if [[ -f /home/michael/update.txt ]]; then
  updates=`/run/current-system/sw/bin/cat /home/michael/update.txt`
else
  updates="No updates today"
fi

/run/current-system/sw/bin/echo -e "Content-Type: text/plain\r\nSubject: Update information for NixOS\r\n\r\n$updates" | sendmail michael8rown@gmail.com

sleep 1

/run/current-system/sw/bin/rm /home/michael/update.txt

