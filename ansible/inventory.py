#! /usr/bin/env python2
import os
import sys
import json


TFSTATE_FILE = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'terraform', 'terraform.tfstate'))


def _get_public_ips(module, node_type):
    return module['outputs']['public_{}_ips'.format(node_type)]['value']


def _get_private_ips(module, node_type):
    return module['outputs']['private_{}_ips'.format(node_type)]['value']


def get_etcd_hosts(module):
    public_ips, private_ips = _get_public_ips(module, 'etcd'), _get_private_ips(module, 'etcd')

    hosts = list(public_ips)
    hostvars = {}

    for i, (public_ip, private_ip) in enumerate(zip(public_ips, private_ips)):
        hostvars[public_ip] = {
            'private_ip': private_ip,
            'etcd_name': 'etcd{}'.format(i),
        }

    initial_cluster = ','.join(['{}=https://{}:2380'.format(hostvar['etcd_name'], hostvar['private_ip'])
                                for _, hostvar in hostvars.items()])

    return {
        'hosts': hosts,
        'vars': {
            'initial_cluster': initial_cluster,
            'cert_dir': '/etc/etcd',
        }}, hostvars


def get_controller_hosts(etcd_servers, module):
    public_ips, private_ips = _get_public_ips(module, 'kube_controller'), _get_private_ips(module, 'kube_controller')

    hosts = list(public_ips)
    hostvars = {}

    for i, (public_ip, private_ip) in enumerate(zip(public_ips, private_ips)):
        hostvars[public_ip] = {
            'private_ip': private_ip,
            'controller_name': 'controller{}'.format(i),
        }

    return {
        'hosts': hosts,
        'vars': {
            'etcd_servers': ','.join([
                'https://{}:2379'.format(ip) for ip in etcd_servers
            ]),
            'cert_dir': '/var/lib/kubernetes',
        }
    }, hostvars


def get_worker_hosts(api_servers, module):
    public_ips, private_ips = _get_public_ips(module, 'kube_worker'), _get_private_ips(module, 'kube_worker')

    hosts = list(public_ips)
    hostvars = {}

    for i, (public_ip, private_ip) in enumerate(zip(public_ips, private_ips)):
        hostvars[public_ip] = {
            'private_ip': private_ip,
            'worker_name': 'worker{}'.format(i),
        }

    return {
        'hosts': hosts,
        'vars': {
            'api_servers': ','.join([
                'https://{}:6443'.format(ip) for ip in api_servers]),
            'cert_dir': '/var/lib/kubernetes',
            'kube_proxy_master_ip': private_ips[0],
        }
    }, hostvars


if __name__ == '__main__':
    if not os.path.exists(TFSTATE_FILE):
        sys.stderr.write('No terraform state file; pleasse run `terraform apply` first\n')
        print('{}')
        os.exit(0)

    with open(TFSTATE_FILE) as f:
        tfstate = json.load(f)

    module = tfstate['modules'][0]

    etcd, etcd_hostvars = get_etcd_hosts(module)
    controller, controller_hostvars = get_controller_hosts(etcd['hosts'], module)
    worker, worker_hostvars = get_worker_hosts(controller['hosts'], module)

    inventory = {
        'etcd': etcd,
        'controller': controller,
        'worker': worker,
        '_meta': {
            'hostvars': {}
        }
    }

    inventory['_meta']['hostvars'].update(etcd_hostvars)
    inventory['_meta']['hostvars'].update(controller_hostvars)
    inventory['_meta']['hostvars'].update(worker_hostvars)

    print(json.dumps(inventory))
