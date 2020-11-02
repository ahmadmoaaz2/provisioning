#/bin/bash

APP="/home/todoapp/app"
REPO="https://github.com/timoguic/ACIT4640-todo-app.git"

git clone $REPO $APP
npm install --prefix $APP
sed -i 's/CHANGEME/acit4640/g' $APP/config/database.js
chmod a+rx /home/todoapp