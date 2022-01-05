# AWS Load Balancer Controller

Ingress를 제어하기 위한 Ingress Controller 중 하나. 외부 트래픽을 받기 위해서 필요한 컴포넌트이다.

## 동작 방식
- ALB를 한 대 띄우고, svc는 target group으로, ingress는 listener와 listener rule로 만들어서 외부 트래픽을 내부 svc에 전달한다.

## 설치 방법
- https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/deploy/installation
- https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html 의 prerequisite

## 주의사항
- 위 설치 방법 중간에 보면 IAM OIDC provider를 생성하는 부분이 있는데, 이미 되어 있으면 굳이 하지 않아도 된다(클러스터 당 1번만 하면 됨).
