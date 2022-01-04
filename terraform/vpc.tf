// 1. VPC
// 2. public subnet 2개
// 3. public subnet의 인터넷 연결을 위한 internet gateway
// 4. 2의 모든 outbound traffic을 3으로 보내는 route와 route table
// 5. 4를 2에 붙이기 위한 route table association(subnet당 1개)
// 6. private subnet 2개
// 7. private subnet의 인터넷 연결을 위한 nat gateway
// 8. 7을 위한 eip
// 9. 6의 모든 outbound traffic을 7로 보내는 route와 route table
// 10. 9를 6에 붙이기 위한 route table association(subnet당 1개)
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "swann-eks-cluster-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    // https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#vpc-subnet-tagging
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    // https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/?nc1=h_ls
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    // https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#vpc-subnet-tagging
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    // https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/?nc1=h_ls
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
