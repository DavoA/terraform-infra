resource "helm_release" "argocd" {
  name             = "arggocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.3.11"
  values = [templatefile("argo-values.yaml", {
    client_id     = 
    client_secret = 
  })]
}
