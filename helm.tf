resource "null_resource" "apply_metallb" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -f ./kubernetes/metallb.yaml
    EOT
  }
}

resource "null_resource" "apply_l2" {
  provisioner "local-exec" {
    command = <<EOT
      sleep 45s
      kubectl apply -f ./kubernetes/addresspool.yaml
    EOT
  }
  depends_on = [ null_resource.apply_metallb ]
}

resource "helm_release" "argocd" {
  name             = "arggocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.3.11"
  values = [templatefile("helm/argo-values.yaml", {
    client_id     = "Ov23liuDy4plWTk94jBr"
    client_secret = "23098a18d6d42efcff47e7c709a808f644137dfb"
  })]
  depends_on = [
    null_resource.apply_l2
  ]
}

