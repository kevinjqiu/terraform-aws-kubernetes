resource "aws_key_pair" "kube" {
    key_name = "kubernetes"
    public_key = "${file("keys/id_rsa.pub")}"
}
