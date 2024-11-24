# Create VPC
resource "aws_vpc" "technical_test_vpc" {
  cidr_block = var.vpc_cidr_block
}

# Create Public Subnet
resource "aws_subnet" "technical-test-public" {
  vpc_id     = aws_vpc.technical_test_vpc.id
  cidr_block = var.public_subnet_cidr_block
}

# Create Private Subnet
resource "aws_subnet" "technical-test-private" {
  vpc_id     = aws_vpc.technical_test_vpc.id
  cidr_block = var.private_subnet_cidr_block
}

# Create Internet Gateway
resource "aws_internet_gateway" "technical-test-internet-gateway" {
  vpc_id = aws_vpc.technical_test_vpc.id
}

# NAT Gateway
## Creating an Elastic IP for the NAT Gateway!

resource "aws_eip" "technical-test-nat-eip" {
  vpc = true
}

## Creating a NAT Gateway
resource "aws_nat_gateway" "technical-test-nat-gateway" {
  # Allocating the Elastic IP to the NAT Gateway
  allocation_id = aws_eip.technical-test-nat-eip.id

  # Associating it in the Public Subnet
  subnet_id     = aws_subnet.technical-test-public.id
}

# Create Route Table
resource "aws_route_table" "technical-test-routing-table" {
  vpc_id = aws_vpc.technical_test_vpc.id

  # NAT Rule for internet access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.technical-test-internet-gateway.id
  }

}

#resource "aws_route" "proute_table_idublic_route" {
#  route_table_id         = aws_route_table.technical-test-routing-table.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id             = aws_internet_gateway.technical-test-internet-gateway.id
#}

# Associate public subnet to the route table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.technical-test-public.id
  route_table_id = aws_route_table.technical-test-routing-table.id
}

# Associate the private subnet to the route table
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.technical-test-private.id
  route_table_id = aws_route_table.technical-test-routing-table.id
}

# Create Security Group (technical-test-ariane-security-group) for (technical-test-ariane) EC2 instance
resource "aws_security_group" "technical-test-ariane-security-group" {
  vpc_id = aws_vpc.technical_test_vpc.id

  ingress {
    description = "Office"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["82.11.22.33/32"]
  }

  ingress {
    description = "VPN"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["81.44.55.87/32"]
  }

  ingress {
    description = "Home"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["87.12.33.88/32"]
  }

  egress {
    description = "Internet outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group (technical-test-falcon-security-group) for (technical-test-falcon) EC2 instance
resource "aws_security_group" "technical-test-falcon-security-group" {
  vpc_id = aws_vpc.technical_test_vpc.id

  ingress {
    description = "technical-test-ariane-security-group"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    security_groups = [aws_security_group.technical-test-ariane-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group (technical-test-redis-security-group) for (technical-test-redis) EC2 instance
resource "aws_security_group" "technical-test-redis-security-group" {
  vpc_id = aws_vpc.technical_test_vpc.id

  ingress {
    description = "technical-test-falcon-security-group"
    from_port   = 6399
    to_port     = 6399
    protocol    = "tcp"
    security_groups = [aws_security_group.technical-test-falcon-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance technical-test-ariane within technical-test-public subnet
# and attach it to the security group technical-test-ariane-security-group
resource "aws_instance" "technical-test-ariane" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.technical-test-public.id
  security_groups = [aws_security_group.technical-test-ariane-security-group.name]
}

# Elastic IPs cannot be directly attached to a subnet.
# They are associated with an Instance or network interface in the subnet
# This why we have to create first a network interface for the technical-test-public subnet
resource "aws_network_interface" "technical-test-public" {
  subnet_id = aws_subnet.technical-test-public.id
}

# Allocate an Elastic IP for technical-test-ariane EC2 instance
resource "aws_eip" "technical_test_ariane_eip" {
  network_interface = aws_network_interface.technical-test-public.id
  instance = aws_instance.technical-test-ariane.id
}

# Create EC2 Instance technical-test-falcon within technical-test-private private subnet
# and attach it to the security group technical-test-redis-security-group
resource "aws_instance" "technical-test-falcon" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.technical-test-private.id
  security_groups = [aws_security_group.technical-test-falcon-security-group.name]
}

# Create EC2 Instance technical-test-redis within technical-test-private private subnet
# and attach it to the security group technical-test-redis-security-group
resource "aws_instance" "technical-test-redis" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.technical-test-private.id
  security_groups = [aws_security_group.technical-test-redis-security-group.name]
}
