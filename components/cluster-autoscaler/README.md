# Cluster Autoscaler

Kubernetes worker node의 수를 현재 리소스 요구사항에 맞춰 자동으로 조절해주는(autoscaling) 컴포넌트이다.

## 설치 방법
- https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html#cluster-autoscaler
1. terraform/cluster-autoscaler.tf의 내용을 프로비저닝한다.
2. 아래의 커맨드를 실행한다.
```bash
kubectl apply -f cluster-autoscaler.yaml
```
