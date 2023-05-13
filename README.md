# Steps require to creating bash script which will read from yaml file and creating snapshots of ebs
## Requirements:
1. AWSCLI needs to installed in your machine. For installing AWSCLI you can follow the official documentation of AWS
[AWSCLI INSTALLATION](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. aws need to be configured. For this create user in aws console.
- IAM->users->add user->provide username->Next->Attach policies directly->Next->create user.
- now click on the user which you have created.
- scroll down and click on security credentials -> Access key.
- Create Access key ->Next->Command line interface(CLI)->agree->Next->create access key
- Copy both access key and security key->Done
3. now in command prompt/linux machine enter the command
   aws configure
- and provide the required details like
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: us-east-1
Default output format [None]:
4. Now chnage the permissions for the .sh file by providing the command
    chmod u+x ebsapp.sh
5. Now, run the command ./ebsapp.sh to start the creation of snapshots.

**note** :Click on the "Attach policies" button.
In the "Filter policies" search bar, type "AmazonEC2FullAccess" and select the policy from the list.

