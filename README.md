# ec2-init-scripts
This is a collection of bash scripts which can be used to set up Amazon Web Services EC2 instances for various purposes.  They are intended to be used as "init scripts" when placed in the "user data" section of the EC2 Launch Configuration, but there is no reason why they can't simply be uploaded to a new EC2 instance and run from root.  It is important to note that EC2 init scripts always run as "root" so these scripts assume this and don't use sudo.

For more information about EC2 init scripts, please read this guide: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html

# Scripts
* ec2-init-jenkins-master-efs.sh - Installs Jenkins and it's dependencies and puts JENKINS_HOME on an EFS (AWS Elastic File System) that must already exist.  Just create an EFS volume and put it's ID (fs-XXXXXXXX) into this script before running.  The EC2 instance must be able to connect to your EFS volume which is easiest to accomplish by placing them in the same subnet and security group.  If this script does not properly mount the EFS volume it's likely a security group or routing problem.

# License

Apache License Version 2.0
See LICENSE file for details and copyright.
