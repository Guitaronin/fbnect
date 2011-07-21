#!/bin/bash

user=arian@174.122.43.76
folder=fbnect
appname=$folder
server_destination_dir=/www
config_file=local_config/env.config

echo "SSHing into server"
ssh -p 1025 $user "cd $server_destination_dir/$folder

echo fetching latest source code
git fetch origin
git rebase origin master

echo hupping unicorn
ls -l local_config/unicorn_hup
local_config/unicorn_hup

exit"

echo Done