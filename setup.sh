#!/run/current-system/sw/bin/bash
set -e -o pipefail

declare -A arr

arr+=(
  ["VAR_USERNAME"]=username 			# your actual username
  ["VAR_YOUR_NAME"]="Firstname Lastname"	# your first and last name, such as John Smith
  ["VAR_MSMTP_EMAIL"]=username@yourdomain.com	# the email address that should be used for `msmtp`
  ["VAR_MSMTP_SERVER"]=mail.yourdomain.com	# the mailserver address, such as `mail.yourdomain.com`
  ["VAR_EMAIL"]=personalemail@gmail.com		# your personal email address, such as `johnsmith@qooqle.com`
  ["VAR_SSH_PORT"]=####			      # the port you use for `sshd`
  ["VAR_HTTP_ROOT"]=/http/root			# the root directory of your webserver, e.g., `/var/www` or `/srv/httpd`
  ["VAR_HOSTNAME"]=hostname			# the name of your machine
)

echo "The following configurations are available:"
echo
find . -type d | grep -E "^./[^.](.){2,}" | sed -E "s/^.\///g"
echo
read -p "Which one would you like to setup? " configuration

if [ ! -d $configuration ]; then
  echo "$configuration wasn't a valid choice. Try again."
  exit
fi

for key in ${!arr[@]}; do
  value=`echo ${arr[${key}]}`
  sed -i "s#${key}#${value}#g" $configuration/*	# ${arr[${key}]}
done
