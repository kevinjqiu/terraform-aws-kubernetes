resource null_resource "ca-certs" {
    provisioner "local-exec" {
        command = "cd certs && make clean-ca"
    }
    provisioner "local-exec" {
        command = "cd certs && make ca.pem"
    }
}

resource null_resource "kubernetes-certs" {
    triggers {
        ips = "${join(",", concat(aws_instance.etcd.*.private_ip,
                                  aws_instance.kube_controller.*.private_ip,
                                  aws_instance.kube_worker.*.private_ip))}"
    }
    provisioner "local-exec" {
        command = "cd certs && make clean-kubernetes"
    }

    provisioner "local-exec" {
        command = "cd certs && make kubernetes-csr.json IPS='${jsonencode(concat(aws_instance.etcd.*.private_ip, aws_instance.etcd.*.public_ip, aws_instance.kube_controller.*.private_ip, aws_instance.kube_controller.*.public_ip, aws_instance.kube_worker.*.private_ip, aws_instance.kube_worker.*.public_ip))}'"
    }

    provisioner "local-exec" {
        command = "cd certs && make kubernetes.pem"
    }
}
