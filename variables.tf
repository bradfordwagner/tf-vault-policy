variable "k8s_clusters" {
  type = set(string)
  default = ["admin", "cicd"]
}
