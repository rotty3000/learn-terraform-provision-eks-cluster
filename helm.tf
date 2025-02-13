provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

resource "helm_release" "nginx_ingress" {
  chart            = "nginx-ingress-controller"
  create_namespace = true
  name             = "nginx-ingress-controller"
  namespace        = "nginx-ingress"
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  version          = "11.6.8"

  set = [
    {
      name  = "service.type"
      value = "LoadBalancer"
    }
  ]
}

## Manual test install
# helm upgrade -i \
#   -n liferay \
#   --create-namespace \
#   -f values-aws.yaml \
#   --version 0.1.31 \
#   liferay oci://ghcr.io/liferaycloud/liferay-helm-chart/charts/liferay
resource "helm_release" "liferay" {
  chart             = "liferay"
  create_namespace  = true
  dependency_update = true
  force_update      = true
  max_history       = 1
  name              = "liferay"
  namespace         = "liferay"
  repository        = "oci://ghcr.io/liferaycloud/liferay-helm-chart/charts"
  reuse_values      = true
  version           = "0.1.33"

  values = [
    file("${path.module}/values-aws.yaml")
  ]
}
