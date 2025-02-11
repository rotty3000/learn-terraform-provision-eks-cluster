# Deploy Liferay to AWS EKS

```shell
helm install -n nginx-system --create-namespace nginx-ingress-controller bitnami/nginx-ingress-controller
```

Get address
```shell
kubectl get svc -n nginx-system nginx-ingress-controller -o jsonpath='{ .status.loadBalancer.ingress[0].hostname }'
```

