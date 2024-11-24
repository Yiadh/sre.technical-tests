
# AWS Infrastructure Setup with Terraform

This repository contains a Terraform configuration file to deploy a basic AWS infrastructure. The setup includes a VPC, public and private subnets, EC2 instances, and associated security groups.

## Prerequisites

Before you begin, ensure the following:

- Terraform is installed.
- AWS credentials are configured in your environment (e.g., via `~/.aws/credentials` or environment variables).
- You have the necessary IAM permissions to create VPCs, subnets, security groups, EC2 instances, and other resources in your AWS account.

---

## Steps to Deploy the Infrastructure

1. **Clone this repository:**
   ```bash
   git clone <repository_url>
   cd <repository_folder>
   ```

2. **Set up Terraform variables:**
   - Edit the `variables.tf` file to define the following:
     - `region`
     - `vpc_cidr_block`
     - `public_subnet_cidr_block`
     - `private_subnet_cidr_block`
     - `ec2_ami`
     - `ec2_instance_type`


3. **Initialize Terraform:**
   - Run the following command to download the necessary providers and set up your working directory:
     ```bash
     terraform init
     ```

4. **Preview the plan:**
   - Check the execution plan to ensure everything looks correct:
     ```bash
     terraform plan
     ```
   - You can generate the execution plan and save it to a file:
     ```bash
     terraform plan -out=tfplan
     ```
     and you can see it in a human-readable format:
     ```bash
     terraform show tfplan
     ```

5. **Apply the configuration:**
   - Apply the configuration to create the resources:
     ```bash
     terraform apply
     ```
     or via:
     ```bash
     terraform apply tfplan
     ```
   - Type `yes` when prompted to confirm.

6. **Verify Deployment:**
   - After deployment, Terraform will output the created resources' details (if configured). You can also verify resources in the AWS Management Console.

7. **Destroy Resources:**
   - To clean up all resources created by this configuration, run:
     ```bash
     terraform destroy
     ```
   - Type `yes` to confirm.

---

## Resources Hierarchy

Dependency Between Resources:
1. **VPC (technical_test_vpc)**
  This is the foundational resource. All other networking resources depend on it.


2. **Subnets (aws_subnet.technical-test-public and aws_subnet.technical-test-private)**
  Depend on the VPC (aws_vpc.technical_test_vpc) because they must belong to it.


3. **Internet Gateway (aws_internet_gateway.technical-test-internet-gateway)**
  Depends on the VPC (aws_vpc.technical_test_vpc) as it needs to be attached to the VPC.


4. **NAT Gateway (aws_nat_gateway.technical-test-nat-gateway)**
  Depends on:
    An Elastic IP (aws_eip.technical-test-nat-eip) for allocation.
    The Public Subnet (aws_subnet.technical-test-public) to associate with the NAT Gateway.

5. **Route Table (aws_route_table.technical-test-routing-table)**
  Depends on the VPC (aws_vpc.technical_test_vpc) as it must belong to the VPC.

6. **Routes in the Route Table**
  For the Internet Gateway:
    Depends on the Internet Gateway (aws_internet_gateway.technical-test-internet-gateway).
  For the NAT Gateway (if configured):
    Depends on the NAT Gateway (aws_nat_gateway.technical-test-nat-gateway).

7. **Route Table Associations**
  Depends on:
  - Route Table
  - Public Subnet (aws_subnet.technical-test-public)
  - Private Subnet (aws_subnet.technical-test-private)

8. **Security Groups**
  - aws_security_group.technical-test-ariane-security-group:
    Attached to technical-test-ariane EC2 instance.
  - aws_security_group.technical-test-falcon-security-group:
    Depends on technical-test-ariane-security-group to allow traffic from its resources.
  - aws_security_group.technical-test-redis-security-group:
    Depends on technical-test-falcon-security-group to allow traffic from its resources.

9. **EC2 Instances**

  - technical-test-ariane (aws_instance.technical-test-ariane):
    Depends on:
    - Public Subnet (aws_subnet.technical-test-public).
    - Its Security Group (aws_security_group.technical-test-ariane-security-group).

  - technical-test-falcon (aws_instance.technical-test-falcon):
    Depends on:
    - Private Subnet (aws_subnet.technical-test-private).
    - Its Security Group (aws_security_group.technical-test-falcon-security-group).

  - technical-test-redis (aws_instance.technical-test-redis):
    Depends on:
    - Private Subnet (aws_subnet.technical-test-private).
    - Its Security Group (aws_security_group.technical-test-redis-security-group).

10. **Network Interface (aws_network_interface.technical-test-public)**
    Depends on the Public Subnet (aws_subnet.technical-test-public).

11. **Elastic IP for technical-test-ariane EC2 instance (aws_eip.technical_test_ariane_eip)**
    Depends on:
    - A network interface created for the public subnet (aws_network_interface.technical-test-public).
    - The technical-test-ariane EC2 instance for association.

## Resources Purpose

Below is a breakdown of the resources and their roles:

1. **VPC (`technical_test_vpc`):**
   - The main container for all networking resources.
   - Customizable via the `vpc_cidr_block` variable.

2. **Subnets:**
   - **Public Subnet (`technical-test-public`)**:
     - Hosts the `technical-test-ariane` EC2 instance.
     - Provides internet access through an Internet Gateway.
   - **Private Subnet (`technical-test-private`)**:
     - Hosts the `technical-test-falcon` and `technical-test-redis` EC2 instances.
     - Provides internet access through a NAT Gateway.

3. **Internet Gateway (`technical-test-internet-gateway`):**
   - Enables internet access for resources in the public subnet.

4. **NAT Gateway (`technical-test-nat-gateway`):**
   - Provides internet access for instances in private subnets.

5. **Route Table:**
   - **Route Table (`technical-test-routing-table`)**:
     - Routes traffic to the Internet Gateway for the public subnet.
     - Public and Private subnets are associated with the Route Table

6. **Security Groups:**
   - **technical-test-ariane-security-group**:
     - Allows HTTPS (port 443) traffic from specified CIDR blocks.
   - **technical-test-falcon-security-group**:
     - Restricts access to traffic from `technical-test-ariane` EC2 instance on port 4000.
   - **technical-test-redis-security-group**:
     - Restricts access to traffic from `technical-test-falcon` EC2 instance on port 6399.

7. **Elastic IPs:**
   - Allocated for both the NAT Gateway and the `technical-test-ariane` EC2 instance for external access.

8. **EC2 Instances:**
   - **technical-test-ariane**:
     - Deployed in the public subnet with an Elastic IP for internet access.
   - **technical-test-falcon**:
     - Deployed in the private subnet, communicates with `technical-test-ariane`.
   - **technical-test-redis**:
     - Deployed in the private subnet, communicates with `technical-test-falcon`.

---
