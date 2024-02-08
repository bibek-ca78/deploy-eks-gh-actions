# eks.tf

# Create an IAM role for the EKS service
resource "aws_iam_role" "eks_service_role" {
  name               = "eks_service_role"
  assume_role_policy = data.aws_iam_policy_document.eks_service_role.json
}

# Attach the necessary IAM policies to the EKS service role
data "aws_iam_policy_document" "eks_service_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_service_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_group_ids = [aws_security_group.eks_security_group.id]
  }
}

# output "kubeconfig" {
#   value = aws_eks_cluster.my_cluster.kubeconfig
# }

# Adding Node Group

# Create an IAM role for the node group
resource "aws_iam_role" "eks_node_group_role" {
  name               = "eks_node_group_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Create an IAM policy for the node group to access necessary resources
resource "aws_iam_policy" "eks_node_group_policy" {
  name        = "eks_node_group_policy"
  description = "Policy for EKS node group"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeVpcs",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "eks:DescribeCluster",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeScalingProcessTypes",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      Resource = "*"
    }]
  })
}

# Attach the IAM policy to the node group role
resource "aws_iam_role_policy_attachment" "eks_node_group_policy_attachment" {
  policy_arn = aws_iam_policy.eks_node_group_policy.arn
  role       = aws_iam_role.eks_node_group_role.name
}

# Create the node group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] # Specify the subnets where the nodes will be deployed

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"] # Specify instance types for the nodes
}

