resource "aws_iam_policy" "external_dns" {
  name = "${local.cluster_name}-external-dns"
  description = "IAM policy for ExternalDNS pods"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOT
}

resource "aws_iam_role" "external_dns" {
  name = "${local.cluster_name}-external-dns"
  description = "IAM role for ExternalDNS pods"

  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::563057296362:oidc-provider/${local.oidc_provider}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${local.oidc_provider}:sub": "system:serviceaccount:kube-system:external-dns"
        }
      }
    }
  ]
}
EOT
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  policy_arn = aws_iam_policy.external_dns.arn
  role       = aws_iam_role.external_dns.name
}

resource "aws_route53_zone" "api_suhwan_dev" {
  name = "api.suhwan.dev"
}

output "external_dns_hosted_zone_id" {
  value = aws_route53_zone.api_suhwan_dev.zone_id
}

output "external_dns_name_servers" {
  value = aws_route53_zone.api_suhwan_dev.name_servers
}
