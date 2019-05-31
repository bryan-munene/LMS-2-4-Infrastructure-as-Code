# LMS-2-4-Infrastructure-as-Code

Create a vpc on AWS using Terraform

## Technologies Used

- [Packer](https://packer.io/downloads.html)

- [Terraform](https://www.terraform.io/)

- [Ansible](https://www.ansible.com/)

- [AWS](https://aws.amazon.com/)

## Introduction

This repository automates the creation of a VPC(Virtual Private Cloud) and custom-made AMI(Amazon Machine Image) in AWS. The VPC contains a Public and Private subnet, an Internet gateway, a NAT instance, Route tables, Load balancers, a Bastion Host, as well as all the relevant security groups. 
The application's backend (API) and database reside in a private subnet(not accessible via the internet) while the frontend resides in a public subnet (accessible via the internet).

## Files

### Packer

In this repo, there are three packer files, for the frontend, backend and database instances. These packer files are used to build and provision the AMIs we would use as base images for our instances.

### Terraform

After the AMIs have been built and provisioned, **terraform** is used to automatically build our infrastructure. Terraform configuration is described using a high-level configuration syntax. The terraform configurations can be found in the **terraform** folder.

#### Variables file

This file holds all the variables used by this terraform configuration. It also provides a default value that is used if no value was provided.
The `AWS_ACCESS_KEY_ID` and the `AWS_SECRET_ACCESS_KEY` variables hold the aws authentication keys of the aws account you want to use to build your infrastructure.

#### Vpc file

This file holds configurations used to create:

1. **VPC:**

 A Virtual Private Cloud (VPC) lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define.

2. **Subnets:**

 A subnet is a logical partition of an IP network into multiple, smaller network segments. It is typically used to subdivide large networks into smaller, more efficient subnetworks. It is a network within a network. Here we create 2 subnets; `Public` and `Private` subnet. The public subnet can be accessed over the internet while the private on can only be accessed from within the `VPC`.

3. **Route tables:**

 Route tables are created to define how traffic would be routed from each subnet.

4. **internet gateway:**

 Traffic from the Public subnet will be routed here.

5. **NAT instance:**

 Traffic from the Private subnet will be routed here.

6. **Route table associations:**

 These are used to associate each route table to a specific subnet. 
 
7. **Security groups**

 Security groups acts as a firewall for your instance to control traffic `in` and `out` of the instance. In this file we declare security groups for the `subnets`, the `instances` and the `load balancers`

All these configurations are declared and described in this file(`vpc.tf`).

#### Resources file

This file defines all the instances that will be launched in our VPC. These instances are:

1. **NAT instance:**

 Here we create an instance from the AMI built with packer earlier. It is put in the public subnet and given its own security group.

2. **Elastic Load balancer:**

 Here we creates two loadbalancers, one priavte load balancer for the private subnet and one public load balancer for the public subnet, associate them with their respective instances and configures the port on which it should listen and allthe health checks it should perform.

3. **Instances:**

 Here we create all the three instances mentinoned in the Packer section above. The 3 instances are assigned relevant security groups and assigned to the relevant subnet.

4. **Bastion Host:**

 Here we create a bastion host and assign it the relevant security group and place it in the public subnet.

#### AMI file

This file describes the AMI to be used in the creation of the above named instances. Filters are used to filter by name from a list of AMIs owned by the account specified in `owners`. The AMIs retrieved are then used to launch the various instances.

## Getting started

1. Install **packer** and **terraform**.

2. In the `terraform` folder, create a `terraform.tfvars` file that contains your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`in this format:

```
AWS_ACCESS_KEY_ID = "**********"
AWS_SECRET_ACCESS_KEY = "************"
```

3. Next we need to define the private key pair that we'll use to access our instances. First you need to create a key pair on AWS and download it. Then we will use that private key pair to generate a public key which we will be able to use.
Run the following command to generate a publick key and store it in file named `public_key` in the root directory:

```
ssh-keygen -y -f ~/path/to/your/keypair.pem
```

4. In the `Packer directory`, create a `vars.json` file. This file would contain the variables that packer would use to build the AMIs.

```
{
    "aws_access_key":"YOUR AWS ACCESS KEY",
    "aws_secret_key":"YOUR AWS SECRET KEY",
    "vpc_region":"YOUR AWS REGION OF CHOICE",
    "instance_type":"YOUR INSTANCE TYPE OF CHOICE",
    "ssh_username":"USERNAME"
 }
```

5. Run the following command to make `start.sh` script executable:

```
chmod +x start.sh
```

7. Proceed to run the script that automates all the process of building the AMIs and building the infrastructure by running:

```
./start.sh
```

If all goes well, you should have:

 1. 3 AMIs built and all your terraform resources built on AWS.

 2. The frontend application can be accessed from the `public laodbalancer` and the backend from the `private laodbalancer`

To access the application throgh the loadbalancer, you need to get the `public dns address` of the `public loadbalancer` and use it as the URL.

**Congratulations!!!** You have successfully deployed an application to a VPC on AWS using Terraform.

## TEAR DOWN

To destroy the infrastructure that we have ste up above is really very easy.

### Steps

1. You need to get into the `terraform` directory where all the terraform scripts are.

    ```
    cd terraform
    ```

2. Then run the following command to destroy the infrstructure.

    ```
    terraform destroy "tfdemo"
    ```

That's it! Now you can set up and destroy the infrastructure.
