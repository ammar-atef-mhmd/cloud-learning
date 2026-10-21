#! /usr/bin/env bash
#التحقق من الصلاحيات الادارية
if [[ $EUID -ne 0 ]]; then
echo "You have no access"
exit 1
else
echo "Wilcome Admin"
fi
sudo apt update && sudo apt install -y git curl
mkdir my_project
chmod 700 my_project
chown -R $USER:$USER my_project
cd my_project
git init

