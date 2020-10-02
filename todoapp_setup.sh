#!/bin/bash


scp setup/mongodb-org4.4.repo todoapp:/home/admin/mongodb-org4.4.repo
scp setup/todoapp.service todoapp:/home/admin/todoapp.service
scp setup/nginx.conf todoapp:/home/admin/nginx.conf
scp setup/setup-script.sh todoapp:/home/admin/setup-script.sh

ssh todoapp sudo bash /home/admin/setup-script.sh
