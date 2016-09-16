output "ips" {
    value = ["${aws_instance.etcd.public_ip}"]
}

output "public_etcd_ips" {
    value = ["${aws_instance.etcd.0.public_ip}"]
}

output "private_etcd_ips" {
    value = ["${aws_instance.etcd.*.private_ip}"]
}

output "public_kube_controller_ips" {
    value  = ["${aws_instance.kube_controller.*.public_ip}"]
}

output "private_kube_controller_ips" {
    value = ["${aws_instance.kube_controller.*.private_ip}"]
}

output "public_kube_worker_ips" {
    value = ["${aws_instance.kube_worker.*.public_ip_address}"]
}

output "private_kube_worker_ips" {
    value = ["${aws_instance.kube_worker.*.private_ip_address}"]
}
