# quant_submission
Hello World App

Hi there!

Step 1:
Please create a user an AWS Account with VPC and EC2 Admin permissions
Save the aws_access_key_id
save the aws_secret_access_key.
create a profile with this details in the "~/.aws/credentials" directory of the computer where you will run the terraform scripts

Step 2
Create a folder called submission  
Navigate into submission folder:
Git clone the repository (https://github.com/archyemi/quant_sub.git)
Up variables in the variables.tf as needed and save the file
Run "terraform init" to initialize the directory
Run "terraform plan"
Validate the resources to be created
Run "terraform apply" 
enter "yes"

Step 3
copy the url of the external-facing loadbalancer
Paste the url in any browser to view the application

Step 4
Run "terraform destroy" to clean up resources
