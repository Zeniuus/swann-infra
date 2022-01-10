# ExternalDNS

Ingress 리소스를 제어하기 위해 AWS Load Balancer Controller가 생성하는 ALB의 endpoint를 원하는 도메인 주소로 설정하기 위한 컴포넌트이다.

## 설치 방법
- https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/alb-ingress.md
- https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.1/guide/integrations/external_dns/
1. terraform/external-dns.tf의 내용을 프로비저닝한다.
2. 도메인을 구매한 사이트에 가서 api.suhwan.dev에 대해 1의 output에 나온 name_server 목록을 확인하게 하는 NS record를 추가한다.
3. 아래의 커맨드를 실행한다.
```bash
kubectl apply -f external-dns.yaml --namespace kube-system
```
