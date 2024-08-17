

resource "kubernetes_manifest" "metallb-addresspool" {
  manifest = yamldecode(file("kubernetes/addresspool.yaml"))

  depends_on = [ helm_release.metallb ]
}

resource "kubernetes_manifest" "metallb-advertisement" {
  manifest = yamldecode(file("kubernetes/advertisement.yaml"))

  depends_on = [ helm_release.metallb ]
}