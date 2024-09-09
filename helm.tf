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

resource "helm_release" "argocd-apps" {
  name = "argoapps"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argocd-apps"
  namespace = "argocd"
  version = "2.0.0"
  depends_on = [ helm_release.argocd ]
}



resource "null_resource" "install_ingress" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -f ./kubernetes/ingress-namespace.yaml
      helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx;
      helm repo update;
      helm install ingress-release ingress-nginx/ingress-nginx --version 4.11.2 -n ingress-nginx
    EOT
  }
  depends_on = [helm_release.argocd]
}

resource "null_resource" "install_app_set_crd" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/applicationset/v0.1.0/manifests/install.yaml
    EOT
  }

  depends_on = [helm_release.argocd]
}

