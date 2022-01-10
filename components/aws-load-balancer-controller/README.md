# AWS Load Balancer Controller

Ingress를 제어하기 위한 Ingress Controller 중 하나. 외부 트래픽을 받기 위해서 필요한 컴포넌트이다.

## 동작 방식
- ALB를 한 대 띄우고, svc는 target group으로, ingress는 listener와 listener rule로 만들어서 외부 트래픽을 내부 svc에 전달한다.

## 설치 방법
- https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html 의 prerequisite
- https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
1. terraform/aws-load-balancer-controller.tf의 내용을 프로비저닝한다.
2. 아래의 커맨드를 실행한다.
```bash
$ helm repo add eks https://aws.github.io/eks-charts
$ helm repo update
$ helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=swann-eks-cluster \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::563057296362:role/swann-eks-cluster-aws-load-balancer-controller
```

## 주의사항
- 위 설치 방법 중간에 보면 IAM OIDC provider를 생성하는 부분이 있는데, 이미 되어 있으면 굳이 하지 않아도 된다(클러스터 당 1번만 하면 됨).
