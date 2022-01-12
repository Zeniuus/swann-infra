resource "random_password" "main_db_password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "aws_db_parameter_group" "main_db" {
  name   = "main-db"
  family = "mysql5.7"

  // 장소 / 건물 데이터 마이그레이션 파일의 사이즈가 기본 max_allowed_packet의 크기보다 커서 조정해준다.
  parameter {
    name  = "max_allowed_packet"
    value = "41943040"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
}

resource "aws_db_instance" "main_db" {
  name                 = "our_map"
  instance_class       = "db.t2.micro"
  port                 = 3306

  engine               = "mysql"
  engine_version       = "5.7.34"
  parameter_group_name = aws_db_parameter_group.main_db.name

  storage_type         = "gp2"
  allocated_storage    = 20

  vpc_security_group_ids = [aws_security_group.main_db.id]

  username             = "root"
  password             = random_password.main_db_password.result
  skip_final_snapshot  = true
}

resource "aws_security_group" "main_db" {
  name        = "db"
  description = "db instance sg"
  vpc_id      = data.aws_vpc.default.id

  egress {
    description      = "Egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "main_db_allow_eks_worker_node" {
  description = "Allow EKS worker node connection"

  security_group_id        = aws_security_group.main_db.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = "sg-08c24c379522b57fc" # FIXME: 원래는 module.eks.node_security_group_id이어야 하는데, 이 output이 없다고 해서 임시로 하드코딩함
  protocol                 = "tcp"

  depends_on = [aws_vpc_peering_connection.eks_vpc_default_vpc]
}

resource "aws_vpc_peering_connection" "eks_vpc_default_vpc" {
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = module.vpc.vpc_id
  auto_accept   = true
}

resource "aws_route" "eks_vpc_to_default_vpc" {
  for_each = toset(module.vpc.private_route_table_ids)
  route_table_id = each.key
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_vpc_default_vpc.id
}

resource "aws_route" "default_vpc_to_eks_vpc" {
  route_table_id = data.aws_vpc.default.main_route_table_id
  destination_cidr_block = module.vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_vpc_default_vpc.id
}
