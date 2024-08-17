resource "helm_release" "argocd" {
  name             = "arggocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.3.11"
  values = [templatefile("helm/argo-values.yaml", {
    client_id     = "Ov23liuDy4plWTk94jBr"
    client_secret = "b6ad9bb342daac106361caed451d420c22dfbabb"
  })]
}

resource "helm_release" "metallb" {
  name             = "metallb"
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  namespace        = "metallb-system"
  create_namespace = true
}
