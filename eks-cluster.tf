resource "aws_eks_cluster" "eks" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.eks-role.arn
  vpc_config {
    subnet_ids = flatten([aws_subnet.private[*].id, aws_subnet.public[*].id])
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks-role-policy]
}