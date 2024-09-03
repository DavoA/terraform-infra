# resource "kubernetes_manifest" "metallb-namespace" {
#   manifest = yamldecode(file("kubernetes/mlb-namespace.yaml"))
# }

# resource "kubernetes_manifest" "metallb-addresspool" {
#   manifest  = yamldecode(file("kubernetes/addresspool.yaml"))
#   depends_on = [kubernetes_manifest.metallb-advertisement]
# }

# resource "kubernetes_manifest" "metallb-advertisement" {
#   manifest   = yamldecode(file("kubernetes/advertisement.yaml"))
#   depends_on = [null_resource.apply_metallb]
# }

# resource "kubernetes_manifest" "argocd-namespace" {
#   manifest = yamldecode(file("kubernetes/argocd-namespace.yaml"))
# }
