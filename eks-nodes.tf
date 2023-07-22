resource "aws_eks_node_group" "eks-node" {
  cluster_name  = aws_eks_cluster.eks.name
  node_role_arn = "${var.project}-eks-node"
  subnet_ids    = flatten([aws_subnet.private[*].id])
  capacity_type = "ON_DEMAND"
  instance_types = ["t3.small"]
  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }
}