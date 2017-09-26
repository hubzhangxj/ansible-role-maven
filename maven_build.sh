#!/bin/bash
#CURDIR=$(cd `dirname $0`; pwd)
#set in configure.yml responding to scripts

#echo "export MAVEN_HOME=/usr/local/maven/apache-maven-3.3.9" >> /etc/profile
#echo "export PATH=$PATH:$MAVEN_HOME/bin" >> /etc/profile
source /etc/profile

pushd ../../ > /dev/null

ansible-playbook -i hosts site.yml  -vvv --user=root --extra-vars "ansible_sudo_pass=root" &

popd > /dev/null
