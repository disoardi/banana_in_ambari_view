#!/bin/bash

echo "Add repo for maven"
curl -o /etc/yum.repos.d/epel-apache-maven.repo https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo

echo "Install maven"
yum -y install apache-maven

echo "Clone iframe-view repo"
cd /opt
git clone https://github.com/abajwa-hw/iframe-view.git
cd iframe-view


echo "Config view"
sed -i "s/iFrame View/Banana dashboard/g" /opt/iframe-view/src/main/resources/view.xml
sed -i "s/IFRAME_VIEW/BANANA_DASHBOARD/g" /opt/iframe-view/src/main/resources/view.xml
sed -i "s/6080/3000g" /opt/iframe-view/src/main/resources/index.html
sed -i "s/iframe-view/banana_dashboard-view/g" /opt/iframe-view/pom.xml
sed -i "s/Ambari iFrame View/Banana dashboard view/g" /opt/iframe-view/pom.xml

echo "Start mvn build"
mvn clean package

echo "Move jar to Ambari dir"
cp target/*.jar /var/lib/ambari-server/resources/views

echo "Restart Ambari server"
ambari-server restart
