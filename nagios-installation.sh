#!/bin/sh
##################################################################
## script to install and configure nagios core on RHEL7/CentOS7
## tested on vagrant box "bento/centos-7.3"
##################################################################
echo "----Install LAMP Server on CentOS7/RHEL7----"

# Install all packages in a single command.

sudo yum -y install httpd php gcc glibc glibc-common wget perl gd gd-devel unzip zip

echo "----Create a nagios user and nagcmd group for allowing the external commands to be executed through the web interface, add the nagios and apache user to be a part of the nagcmd group----"

sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
sudo usermod -a -G nagcmd apache

echo "----Download latest Nagios Core----"

cd /tmp/
sudo wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.4.tar.gz
sudo tar -zxvf /tmp/nagios-4.*.tar.gz
cd /tmp/nagios-4.*

echo "----Compile and Install Nagios----"

sudo ./configure --with-nagios-group=nagios --with-command-group=nagcmd
sudo make all
sudo make install
sudo make install-init
sudo make install-config
sudo make install-commandmode

echo "----Install Nagios web configuration----"

sudo make install-webconf
sudo make install-exfoliation

echo "----Enable nagios service----"

sudo systemctl enable httpd.service

echo "----Restart nagios service----"

sudo systemctl restart httpd.service
sudo systemctl restart nagios.service

echo "----Nagioscore Setup Complete!!!!----"

### Run following command to create a user account (nagiosadmin) for nagios web interface post nagios setup completion!

### htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin




##################################################################
