resource "aws_elb" "kube" {
    name            = "kubernetes"

    security_groups = ["${aws_security_group.kube.id}"]
    subnets         = ["${aws_subnet.kube.id}"]
    instances       = ["${aws_instance.kube_controller.*.id}"]
    listener {
        instance_protocol  = "TCP"
        instance_port      = 6443
        lb_protocol        = "TCP"
        lb_port            = 6443
    }
}
