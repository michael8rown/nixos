#!/run/current-system/sw/bin/bash

if [[ -f /home/VAR_USERNAME/update.txt ]]; then
  updates=`/run/current-system/sw/bin/cat /home/VAR_USERNAME/update.txt`
else
  updates="No updates today"
fi

/run/current-system/sw/bin/echo -e "Content-Type: text/plain\r\nSubject: Update information for NixOS\r\n\r\n$updates" | sendmail VAR_EMAIL

sleep 1

/run/current-system/sw/bin/rm /home/VAR_USERNAME/update.txt

