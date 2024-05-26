#!/bin/bash
set -e -o pipefail

declare -A arr

arr+=(
  ["VAR_USERNAME"]=username 			# your actual username
  ["VAR_YOUR_NAME"]="Firstname Lastname"	# your first and last name, such as John Smith
  ["VAR_MSMTP_EMAIL"]=username@yourdomain.com	# the email address that should be used for `msmtp`
  ["VAR_MSMTP_SERVER"]=mail.yourdomain.com	# the mailserver address, such as `mail.yourdomain.com`
  ["VAR_EMAIL"]=personalemail@gmail.com		# your personal email address, such as `johnsmith@qooqle.com`
  ["VAR_SSH_PORT"]=####				# the port you use for `sshd`
  ["VAR_HTTP_ROOT"]=/http/root			# the root directory of your webserver, e.g., `/var/www` or `/srv/httpd`
  ["VAR_HOSTNAME"]=hostname			# the name of your machine
  ["VAR_PROFILE"]=profile			# the profile you're installing, laptop or server
)

for key in ${!arr[@]}; do
  value=`echo ${arr[${key}]}`
  find . -type f $(printf "! -name %s " setup.sh) -print0 | xargs -0 sed -i "s#${key}#${value}#g"	# ${arr[${key}]}
done

echo "All variables have been updated."
echo "Move all contents of this folder to your main configuration folder, such as /etc/nixos, e.g.,"
echo
echo "      mv * /etc/nixos/."
echo

