# Deploy Liferay to AWS EKS

### Login with your AWS account

```shell
aws sso login --profile <aws_profile>
```

_(you may have to set the default profile env variable)_

```shell
export AWS_PROFILE=<aws_profile>
```

### Init Terraform

```shell
terraform init
```

### Apply Terraform

```shell
terraform apply
```

### Get the EKS kubernetes credential to setup `kubectl`

```shell
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```

### Get the public HTTP address

```shell
kubectl get svc -n nginx-ingress nginx-ingress-controller -o jsonpath='{ .status.loadBalancer.ingress[0].hostname }'
```
