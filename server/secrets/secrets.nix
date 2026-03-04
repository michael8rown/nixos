# You'll probably need to update the public keys below for the new server.
# Once you do that, generate the age file like this:
#
# sudo su
# EDITOR=nano agenix -e msmtp.age
#
# Enter the password in plain text and save the file

let
	user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEVytAzTSNnK+z0OMkvm+qHy7mj74RUTUDkQ1d4RQvH";
	system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPrvstdMxNQpNwvI6G5lvqA8uyeblirMMptFmwUV+xYW";
in
{
	"msmtp.age".publicKeys = [ user system ];
}

