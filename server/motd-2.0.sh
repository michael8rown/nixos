#!/run/current-system/sw/bin/sh

upSeconds="$(/run/current-system/sw/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60)) mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24)) days=$((${upSeconds}/86400))
DATE=$(/run/current-system/sw/bin/date +'%a %b %d %r %Y')
UPTIME=`/run/current-system/sw/bin/printf "%02dd %02dh %02dm %02ds" "$days" "$hours" "$mins" "$secs"`
OS=`/run/current-system/sw/bin/grep -E "^PRETTY_NAME=" /etc/os-release | /run/current-system/sw/bin/sed -E 's/^PRETTY_NAME="([^\"]*)"/\1/g'`
UPT="Uptime: ${UPTIME}"
#WHO=$(w -shi | sed -E "s/^([^ ]*) +[^ ]* +([^ ]*).*$/\1 \2/g")
WHO=$(/run/current-system/sw/bin/who | /run/current-system/sw/bin/sed -E "s/^([^ ]*).+\(([^ ]*)\)$/\1 \2/g")
if [[ ! $WHO ]]; then
  WHO2="";
else
  WHO2="Users logged in: $WHO"
fi
UNAME=$(/run/current-system/sw/bin/uname -r)
MSG="$DATE\n$OS\n$UNAME\n$UPT\n$WHO2"

/run/current-system/sw/bin/echo -e "Content-Type: text/plain\r\nSubject: SERVERNAME status\r\n\r\n$MSG" | /run/wrappers/bin/sendmail YOUREMAIL@gmail.com
