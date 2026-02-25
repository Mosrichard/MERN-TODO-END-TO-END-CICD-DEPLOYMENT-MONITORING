variable "region" {
    description = "The AWS region where the VPC will be created."
    type        = string
}

// S3 backend variables

variable "bucket" {
    description = "The name of the S3 bucket for Terraform state storage."
    type        = string  
}

variable "key" {
    description = "The Key of the S3 bucket for Terraform state storage."
    type        = string  
}

// VPC variables

variable "vpc-cidr" {
    description = "The CIDR block for the VPC."
    type        = string
}

variable "instance-tenancy" {
    description = "The instance tenancy for the VPC."
    type        = string
}

variable "vpc-name" {
    description = "The name of the VPC."
    type        = string
}

// IGW variables

variable "igw-name" {
    description = "The name of the Internet Gateway."
    type        = string
}

// Public Subnet 1 variables

variable "pub-subnet-1-cidr" {
    description = "The CIDR block for the Public Subnet."
    type        = string
}

variable "pub-subnet-1-az" {
    description = "The Availability Zone for the Public Subnet."
    type        = string
}

variable "pub-subnet-1-name" {
    description = "The name of the Public Subnet."
    type        = string
}

variable "pub-subnet-1-key-name" {
    description = "The key name for the Public Subnet tags."
    type        = string
}

variable "pub-subnet-1-key-value" {
    description = "The key value for the Public Subnet tags."
    type        = string
}

// Public Subnet 2 variables

variable "pub-subnet-2-cidr" {
    description = "The CIDR block for the Public Subnet."
    type        = string
}

variable "pub-subnet-2-az" {
    description = "The Availability Zone for the Public Subnet."
    type        = string
}

variable "pub-subnet-2-name" {
    description = "The name of the Public Subnet."
    type        = string
}

variable "pub-subnet-2-key-name" {
    description = "The key name for the Public Subnet tags."
    type        = string
}

variable "pub-subnet-2-key-value" {
    description = "The key value for the Public Subnet tags."
    type        = string
}

// Private Subnet 1 variables

variable "pri-subnet-1-cidr" {
    description = "The CIDR block for the Private Subnet."
    type        = string
}

variable "pri-subnet-1-az" {
    description = "The Availability Zone for the Private Subnet."
    type        = string
}

variable "pri-subnet-1-name" {
    description = "The name of the Private Subnet."
    type        = string
}

variable "pri-subnet-1-key-name" {
    description = "The key name for the Private Subnet tags."
    type        = string
}

variable "pri-subnet-1-key-value" {
    description = "The key value for the Private Subnet tags."
    type        = string
}

// Private Subnet 2 variables

variable "pri-subnet-2-cidr" {
    description = "The CIDR block for the Private Subnet."
    type        = string
}

variable "pri-subnet-2-az" {
    description = "The Availability Zone for the Private Subnet."
    type        = string
}

variable "pri-subnet-2-name" {
    description = "The name of the Private Subnet."
    type        = string
}

variable "pri-subnet-2-key-name" {
    description = "The key name for the Private Subnet tags."
    type        = string
}

variable "pri-subnet-2-key-value" {
    description = "The key value for the Private Subnet tags."
    type        = string
}

// Eip variables

variable "eip-name" {
    description = "The name of the Elastic IP."
    type        = string
  
}

// NAT Gateway variables

variable "nat-name" {
    description = "The name of the NAT Gateway."
    type        = string
}

// Public Route Table variables

variable "pub-rt-cidr" {
    description = "The CIDR block for the Public Route Table."
    type        = string
}

variable "pub-rt-name" {
    description = "The name of the Public Route Table."
    type        = string
}

// Private Route Table variables

variable "pri-rt-cidr" {
    description = "The CIDR block for the Private Route Table."
    type        = string
}

variable "pri-rt-name" {
    description = "The name of the Private Route Table."
    type        = string
}

// EKS variables

variable "node_instance_type" {
    description = "The instance type for the EKS worker nodes."
    type        = string
}

variable "private_subnet_ids" {
    description = "List of private subnet IDs for EKS worker nodes."
    type        = list(string)
}

variable "node_key_name" {
    description = "The name of the EC2 key pair for EKS worker nodes."
    type        = string
}

variable "public_subnet_ids" {
    description = "List of public subnet IDs for EKS worker nodes."
    type        = list(string)
}