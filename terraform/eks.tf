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
    subnet_ids         = [aws_subnet.public_subnet.id]
    security_group_ids = [aws_security_group.eks_security_group.id]
  }
}

output "kubeconfig" {
  value = aws_eks_cluster.my_cluster.kubeconfig
}
