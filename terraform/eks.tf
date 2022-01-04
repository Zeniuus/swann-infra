// 참고한 문서:
// - https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/complete/main.tf
// - https://github.com/hashicorp/learn-terraform-provision-eks-cluster/blob/main/eks-cluster.tf
// 1. EKS control plane
// 2. EKS managed node groups
// 3. 1을 위한 IAM role & 각종 권한(IAM role policy) 설정
// 4. 2를 위한 IAM role & 각종 권한(IAM role policy) 설정
// 5. 1을 위한 security group
// 6. 2를 위한 security group
// 7. 1과 2 사이의 통신을 위한 security group rule
// 8. 1과 2가 외부 인터넷과 통신하기 위한 security group rule
// 9. EKS control plane에 접근하기 위한 설정 정보
module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = local.cluster_name

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  // Managed Node Groups
  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    worker = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"
      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }
  }

  # AWS Auth (kubernetes_config_map)
  map_users = [
    {
      userarn  = "arn:aws:iam::563057296362:user/Administrator"
      username = "administrator"
      groups   = ["system:masters"]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
