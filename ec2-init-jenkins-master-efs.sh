#!/bin/bash
# EC2 Init Script to install Jenkins and start Ubuntu 18.04 with JENKINS_HOME on an EFS volume.
# Author: Rob Jenks <rob@opensource.io>
set -ex

EFS_ID="fs-XXXXXXXX" # UPDATE THIS

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"

# Add the Jenkins Debian Repo
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

# Upgrade Existing Ubuntu Packages
apt-get -q update
apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade

# Install Necessary Prerequisite Packages
apt-get -q -y install unattended-upgrades nfs-common openjdk-8-jdk binutils

# Install EFS Helper
cd /tmp
git clone https://github.com/aws/efs-utils
cd efs-utils
./build-deb.sh
chown -R _apt build
sudo apt-get -y install ./build/amazon-efs-utils*deb
cd ~

# Create the EFS mount point
mkdir /var/lib/jenkins
# Add the mount to /etc/fstab
grep 'jenkins' /etc/fstab || echo "${EFS_ID}.efs.${EC2_REGION}.amazonaws.com:/ /var/lib/jenkins efs defaults,_netdev 0 0" >> /etc/fstab
# Mount it
mount --target /var/lib/jenkins

# Install Jenkins
apt-get -q -y install jenkins

# Fix the permissions on JENKINS_HOME
chown jenkins:jenkins /var/lib/jenkins

# Make sure Jenkins is started, it is probably already started from the install
systemctl start jenkins
