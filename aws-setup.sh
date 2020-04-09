

## TO DO 
    #finish phase 4
    # write this as a bash script
    # set up PosgreSQL
    # write demo app that persistes to PosgreSQL/serves the DB
    
        # maybe do an EBS volume






# Start to finish how to set up a RHEL server on AWS EC2 by Kirby

#this guide meant for users utlizing osx w/ ssh via terminal and is broken into 4 phases

#PHASE 1 CREATE AN EC2 AWS RHEL INSTANCE 

#PHASE 2 SET UP RAILS ENVIROMENT

#PHASE 3 Creating an RAILS DEV ENVIORMENT AMI (so you dont have to do this all again)

#PHASE 4 WIP Load balancer (Classic Load Balancer)


#PHASE 1 CREATE AN EC2 AWS RHEL INSTANCE 

#Create an AWS Account 

#Go To create Key-Pair in ur ec2 console

#For Name, enter a descriptive name for the new key pair, such as your name, followed by -key-pair, plus the Region name. For example, me-key-pair-useast2.

#Dowload keypair and modify via terminal as so

# chmod 400 your_user_name-key-pair-region_name.pem


# in ec2 console choose you region then add a new security group 

#In the VPC list, select your default VPC for the Region.

    # On the Inbound tab, create the following rules (choose Add Rule for each new rule), and then choose Create:

    #  HTTP from the Type list, and make sure that Source is set to Anywhere (0.0.0.0/0).

    #  HTTPS from the Type list, and make sure that Source is set to Anywhere (0.0.0.0/0)

    # CUSTOM TCP -port -3000 (or whatever port you plan to run ur server on) +  (0.0.0.0/0)

    #  SSH from the Type list. In the Source box, choose My IP to automatically populate the field with the public IPv4 address of your local computer. Alternatively, choose Custom and specify the public IPv4 address of your computer or network in CIDR notation. To specify an individual IP address in CIDR notation, add the routing suffix /32, for example, 203.0.113.25/32. If your company allocates addresses from a range, specify the entire range, such as 203.0.113.0/24.

    # Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.

    # From the console dashboard, choose Launch Instance.

    # The Choose an Amazon Machine Image (AMI) page displays a list of basic configurations, called Amazon Machine Images (AMIs), choose RED HAT Enterprise LINUX"

    # On the Choose an Instance Type page, you can select the hardware configuration of your instance. Select the t2.micro type, which is selected by default. Notice that this instance type is eligible for the free tier.

    # Choose Review and Launch to let the wizard complete the other configuration settings for you.

    # On the Review Instance Launch page, under Security Groups, you'll see that the wizard created and selected a security group for you. You can use this security group, or alternatively you can select the security group that you created when getting set up using the following steps:

    # Choose Edit security groups.

    # On the Configure Security Group page, ensure that Select an existing security group is selected.

    # Select your security group from the list of existing security groups, and then choose Review and Launch.

    # On the Review Instance Launch page, choose Launch.

    # When prompted for a key pair, select Choose an existing key pair, then select the key pair that you created when getting set up.

#view your instance on the ec2 dashboard, copy the DNS

#u can run the following command with path to ur ssh or cd into the folder where you have ur .pem key downloaded

# ssh into the server using the following in terminal
#   ssh -i YOUR-KEY.pem(or path) ec2-user@YOUR-INSTANCE-DNS-URL



# update the server 
    # sudo yum update



# PHASE 1 COMPLETE

# PHASE 2 Set up Rails enviroment 

# there are two ways we can go about this, installing via git or wget, for my sake I am going to do niether and just run a rails basic homepage to prove that the server is up and running

#if u would rather build your rails app locally then wget/git clone it into it, run the following commands


    #GIT
        #sudo yum install git-all

    #wget
        #sudo yum install wget


# install dependencies 
    #sudo yum install -y curl gpg gcc gcc-c++ make


# install RMV (ruby version manager)

    #keys

        #gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

    #we're going to install rails and ruby w/ RVM in one line

        #curl -sSL https://get.rvm.io | bash -s stable --rails

    #now we're going to run a logic script to let us call rmv

        #if sudo grep -q secure_path /etc/sudoers; then sudo sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi

    #lets check out we have a clean install with
        #rvm requirements run

# now we need to install node

    #curl --silent --location https://rpm.nodesource.com/setup_12.x | sudo bash -

    #sudo yum install -y nodejs

# now install yarn

    #curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
    
    #sudo dnf install yarn



# if you want git/wget use git clone/weget ur repo otherwise

    #rails new <YOURP-PROJECT> --skip-git

# now run your server w/ the command rails s + -b 0.0.0.0 (aws makes u add the -b 0 etc)

    #rails s -b 0.0.0.0 
    #for custom port 
    #rails s -p <urPOrt> -b 0.0.0.0


#now you can go back to your dashboard copy your public DNs (IPv4) from the aws instance console and go to it in your url + port for example      

    # http://1.12.12.123:3000/

# PHASE 2 Complete


# PHASE 3 Creating an RAILS DEV ENVIORMENT AMI (so you dont have to do this all again)

 #go to your console and right click on your instance and click create image, lets name it "rails dev enviroment" or whatever

#on your dashboard select AMIs and wait for it clone 

#right click launch and follow the same steps when we first set up the original instance w/security + key pairs

#ssh into it with the new DNS ..everything should be there including the project we spun up(* I recommend going back into your O instance and deleteing the rails project we made so that it truly is blank dev enviroment)

# PHASE 3 COMPLETE


# PHASE 4 Load balancer (Classic Load Balancer)

# go to load balance in your dashboard , hit create load balancer , give it a name (rails-demo-load-balancer), check "Enable advanced VPC configuration", scroll down and add as many subnets as you like, then in the middle of the page determine what port you want to redirect http requests (defualt 80) to in an instance... for mine I want port 3000 since this is where rails will be listening on..

#Select the same security group as always

#HEALTH CHECKS

        # the breakdown is as follows

        # we give it a port to ping (3000)

        # our ping path can just be  "/"

        #Response Timeout - lets set it 5 for demo
        #time out of request

        #Interval - lets set it 5 for demo
        #(every x amount of time I want to make a ping #request to the instance)

        #Unhealthy threshold  - lets set it 2 for demo
        #(if x amount is it the instance is considered unhealthy, the load balance will stop sending traffic to it)

        #Healthy threshold - lets set at 3 for demo
        #(if there are x amount good status res(ex 200) then the instance is considered healthy and send traffic toit)

#check mark both the ec2 instances and click through to create the load balancer

# ssh into both instances (cmd+t in terminal to open two windows)
#make sure both servers are running with rails s -b 0.0.0.0

#you will start to see several ping request come through and then after the healthy threshold we set the server will be open on an http 80 request and then router to 3000 on the backend


### FINISH I NEED TO RENDER AN INDEX HTML TO TEST 