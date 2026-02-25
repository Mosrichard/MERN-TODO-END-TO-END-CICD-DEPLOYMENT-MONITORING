// VPC

resource "aws_vpc" "eks-vpc" {
    cidr_block = var.vpc-cidr
    instance_tenancy = var.instance-tenancy

    tags = {
      Name = var.vpc-name
    }
}

// IGW

resource "aws_internet_gateway" "eks-igw" {
    vpc_id = aws_vpc.eks-vpc.id
    tags = {
        Name = var.igw-name
    }
}

// Subnets

// Public Subnet 1

resource "aws_subnet" "eks-pub-subnet-1" {
    vpc_id = aws_vpc.eks-vpc.id
    cidr_block = var.pub-subnet-1-cidr
    availability_zone = var.pub-subnet-1-az

    tags = {
        Name = var.pub-subnet-1-name
        key = var.pub-subnet-1-key-name
        value = var.pub-subnet-1-key-value
    }

}

// Public Subnet 2

resource "aws_subnet" "eks-pub-subnet-2" {
    vpc_id = aws_vpc.eks-vpc.id
    cidr_block = var.pub-subnet-2-cidr
    availability_zone = var.pub-subnet-2-az

    tags = {
        Name = var.pub-subnet-2-name
        key = var.pub-subnet-2-key-name
        value = var.pub-subnet-2-key-value
    }

}


// Private Subnet 1

resource "aws_subnet" "eks-pri-subnet-1" {
    vpc_id = aws_vpc.eks-vpc.id
    cidr_block = var.pri-subnet-1-cidr
    availability_zone = var.pri-subnet-1-az

    tags = {
        Name = var.pri-subnet-1-name
        key = var.pri-subnet-1-key-name
        value = var.pri-subnet-1-key-value
    }

}

// Private Subnet 2

resource "aws_subnet" "eks-pri-subnet-2" {
    vpc_id = aws_vpc.eks-vpc.id
    cidr_block = var.pri-subnet-2-cidr
    availability_zone = var.pri-subnet-2-az

    tags = {
        Name = var.pri-subnet-2-name
        key = var.pri-subnet-2-key-name
        value = var.pri-subnet-2-key-value
    }

}

// Elastic IP for NAT Gateway

resource "aws_eip" "eks-nat-gateway-eip" {  
    tags = {
      Name = var.eip-name
    }
}

// NAT Gateway

resource "aws_nat_gateway" "eks-nat-gateway" {
    allocation_id = aws_eip.eks-nat-gateway-eip.id
    subnet_id = aws_subnet.eks-pub-subnet-1.id
    tags = {
        Name = var.nat-name     
    }
}

// Public Route Table

resource "aws_route_table" "eks-pub-rt" {
    vpc_id = aws_vpc.eks-vpc.id

    route {
        cidr_block = var.pub-rt-cidr
        gateway_id = aws_internet_gateway.eks-igw.id
    }
  
    tags = {
        Name = var.pub-rt-name
    }
}

// Public Route Table Association with public subnets

resource "aws_route_table_association" "eks-pub-rt-assoc-1" {
    subnet_id = aws_subnet.eks-pub-subnet-1.id
    route_table_id = aws_route_table.eks-pub-rt.id
}

resource "aws_route_table_association" "eks-pub-rt-assoc-2" {
    subnet_id = aws_subnet.eks-pub-subnet-2.id
    route_table_id = aws_route_table.eks-pub-rt.id
}

// Private Route Table

resource "aws_route_table" "eks-pri-rt" {
    vpc_id = aws_vpc.eks-vpc.id

    route {
        cidr_block = var.pri-rt-cidr
        nat_gateway_id = aws_nat_gateway.eks-nat-gateway.id
    }

    tags = {
        Name = var.pri-rt-name
    }
}

// Private Route Table Association with Private subnets

resource "aws_route_table_association" "eks-pri-rt-assoc-1" {
    subnet_id = aws_subnet.eks-pri-subnet-1.id
    route_table_id = aws_route_table.eks-pri-rt.id
}

resource "aws_route_table_association" "eks-pri-rt-assoc-2" {
    subnet_id = aws_subnet.eks-pri-subnet-2.id
    route_table_id = aws_route_table.eks-pri-rt.id
}

// EKS Cluster

resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.29"  

  vpc_config {
    subnet_ids         = [
      aws_subnet.eks-pri-subnet-1.id,
      aws_subnet.eks-pri-subnet-2.id
    ]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

// EKS Cluster Role

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "eks.amazonaws.com" },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

// EKS Cluster Group Role

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

// EKS Worker Node Role

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_registry_read" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


// EKS Security Group Role

# Cluster SG
resource "aws_security_group" "eks_cluster_sg" {
  name   = "eks-cluster-sg"
  vpc_id = aws_vpc.eks-vpc.id  # your existing VPC

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Node SG
resource "aws_security_group" "eks_nodes_sg" {
  name   = "eks-nodes-sg"
  vpc_id = aws_vpc.eks-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Node Group

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [
    aws_subnet.eks-pri-subnet-1.id,
    aws_subnet.eks-pri-subnet-2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = [var.node_instance_type]

  remote_access {
    ec2_ssh_key = var.node_key_name
  }

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_registry_read
  ]
}

//IRSA

# OIDC provider
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd9e1f7"] # default thumbprint
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# IAM role for pod
resource "aws_iam_role" "irsa_s3_role" {
  name = "eks-irsa-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:default:s3-access"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_read_policy" {
  name   = "eks-irsa-s3-read"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:ListBucket"],
        Resource = ["arn:aws:s3:::my-bucket", "arn:aws:s3:::my-bucket/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.irsa_s3_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}
