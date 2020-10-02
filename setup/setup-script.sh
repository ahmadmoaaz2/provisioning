#!/bin/bash

# Make configuration changes here
GIT_URL=https://github.com/timoguic/ACIT4640-todo-app.git
DEDICATED_USER=todoapp


function setup_user {
  sudo useradd $DEDICATED_USER
  sudo usermod -aG wheel $DEDICATED_USER
}

function install_dependencies {
  sudo dnf update -y
  sudo dnf install -y git
  sudo curl -sL https://rpm.nodesource.com/setup_14.x | bash -
  sudo dnf install -y nodejs
  sudo dnf install -y mongodb-org
  sudo dnf install -y epel-release
  sudo dnf install -y nginx
}

function setup_git_repo {
  sudo git clone $GIT_URL /home/$DEDICATED_USER/app
  sudo npm --prefix /home/$DEDICATED_USER/app install /home/$DEDICATED_USER/app
  sudo chmod a+rx /home/$DEDICATED_USER
}

function change_required_files {
  sudo sed 's/CHANGEME/acit4640/g' /home/todoapp/app/config/database.js
  sudo setenforce 0
  sudo sed 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
}

function allow_firewall {
  sudo firewall-cmd --zone=public --add-port=8080/tcp
  sudo firewall-cmd --zone=public --add-port=80/tcp
  sudo firewall-cmd --runtime-to-permanent
}

function start_and_enable_services {
  sudo systemctl daemon-reload
  sudo systemctl enable todoapp
  sudo systemctl start todoapp
  sudo systemctl start nginx
  sudo systemctl enable nginx
  sudo systemctl start mongod
  sudo systemctl enable mongod
}

setup_user

install_dependencies

setup_git_repo

allow_firewall

change_required_files

move_setup_files

start_and_enable_services

echo "Script Setup Completed"