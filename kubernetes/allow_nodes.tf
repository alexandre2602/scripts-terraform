locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks-cluster.certificate_authority.0.data}
  name: ${aws_eks_cluster.eks-cluster.name}
contexts:
- context:
    cluster: ${aws_eks_cluster.eks-cluster.name}
    user: ${aws_eks_cluster.eks-cluster.name}
  name: ${aws_eks_cluster.eks-cluster.name}
current-context: ${aws_eks_cluster.eks-cluster.name}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.eks-cluster.name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.eks-cluster.name}"
KUBECONFIG

  aws_auth = <<AWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-node-service-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
AWSAUTH

}

resource "null_resource" "output" {
  provisioner "local-exec" {
    command = "mkdir -p ${path.root}/output/${var.cluster-name}"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${local.kubeconfig}"
  filename = "${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}"

  depends_on = [
    "null_resource.output",
  ]
}

resource "local_file" "aws_auth" {
  content  = "${local.aws_auth}"
  filename = "${path.root}/output/${var.cluster-name}/aws-auth.yaml"

  depends_on = [
    "null_resource.output",
  ]
}

resource "null_resource" "kubectl" {

  provisioner "local-exec" {
    command = <<COMMAND
      KUBECONFIG=~/.kube/config:${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name} kubectl config view --flatten > ./kubeconfig_merged \
      && mv ./kubeconfig_merged ~/.kube/config \
      && kubectl config set-context ${var.cluster-name} \
      && kubectl config use-context ${var.cluster-name}
    COMMAND
  }

  depends_on = [
    "aws_eks_cluster.eks-cluster",
    "null_resource.output",
  ]
}

resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
    command = <<COMMAND
      export KUBECONFIG=${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}
    COMMAND
  }

  depends_on = [
    "null_resource.kubectl",
  ]
}

resource "null_resource" "aws_auth" {
  provisioner "local-exec" {
    command = "kubectl apply --kubeconfig=${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name} -f ${path.root}/output/${var.cluster-name}/aws-auth.yaml"
  }

  depends_on = [
    "local_file.kubeconfig",
  ]
}