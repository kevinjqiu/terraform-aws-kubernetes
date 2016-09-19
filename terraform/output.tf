output "ips" {
    value = "${jsonencode(concat(aws_instance.etcd.*.public_ip, aws_instance.etcd.*.private_ip,
                                 aws_instance.kube_controller.*.public_ip, aws_instance.kube_controller.*.private_ip,
                                 aws_instance.kube_worker.*.public_ip, aws_instance.kube_worker.*.private_ip,
                                 aws_elb.kube.*.dns_name))}"
}

output "public_etcd_ips" {
    value = ["${aws_instance.etcd.*.public_ip}"]
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
    value = ["${aws_instance.kube_worker.*.public_ip}"]
}

output "private_kube_worker_ips" {
    value = ["${aws_instance.kube_worker.*.private_ip}"]
}

output "api_server_elb" {
    value = "${aws_elb.kube.dns_name}"
}
