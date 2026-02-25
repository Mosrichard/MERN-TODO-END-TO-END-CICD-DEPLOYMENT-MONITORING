region = "ap-south-1"

// VPC

vpc-cidr = "10.0.0.0/16"
instance-tenancy = "default"
vpc-name = "eks-vpc"

// IGW

igw-name = "eks-igw"

// Public Subnet 1

pub-subnet-1-cidr = "10.0.1.0/24"
pub-subnet-1-az = "ap-south-1a"
pub-subnet-1-name = "eks-pub-subnet"
pub-subnet-1-key-name = "kubernetes.io/role/elb"
pub-subnet-1-key-value = "1"

// Public Subnet 2

pub-subnet-2-cidr = "10.0.2.0/24"
pub-subnet-2-az = "ap-south-1b"
pub-subnet-2-name = "eks-pub-subnet-2"
pub-subnet-2-key-name = "kubernetes.io/role/elb"
pub-subnet-2-key-value = "1"

// Private Subnet 1

pri-subnet-1-cidr = "10.0.3.0/24"
pri-subnet-1-az = "ap-south-1a"
pri-subnet-1-name = "eks-pri-subnet-1"
pri-subnet-1-key-name = "kubernetes.io/role/internal-elb"
pri-subnet-1-key-value = "1"

// Private Subnet 2

pri-subnet-2-cidr = "10.0.4.0/24"
pri-subnet-2-az = "ap-south-1b"
pri-subnet-2-name = "eks-pri-subnet-2"
pri-subnet-2-key-name = "kubernetes.io/role/internal-elb"
pri-subnet-2-key-value = "1"

// Eip name

eip-name = "eks-eip"

// NAT Gateway

nat-name = "eks-nat-gateway"

// Public Route Table

pub-rt-cidr = "0.0.0.0/0"
pub-rt-name = "eks-pub-rt"

// Private Route Table

pri-rt-cidr = "0.0.0.0/0"
pri-rt-name = "eks-pri-rt"

// EKS

node_instance_type   = "t3.medium"
node_key_name        = "my-ec2-keypair"

public_subnet_ids    = [eks-pub-subnet-1.id, eks-pub-subnet-2.id]
private_subnet_ids   = [eks-pri-subnet-1.id, eks-pri-subnet-2.id]