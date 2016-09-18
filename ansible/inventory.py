#! /usr/bin/env python2
import os
import sys
import json


TFSTATE_FILE = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'terraform', 'terraform.tfstate'))


def get_etcd_hosts(module):
    public_ips = module['outputs']['public_etcd_ips']['value']
    private_ips = module['outputs']['private_etcd_ips']['value']

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
            'initial_cluster': initial_cluster
        }}, hostvars


if __name__ == '__main__':
    if not os.path.exists(TFSTATE_FILE):
        sys.stderr.write('No terraform state file; pleasse run `terraform apply` first\n')
        print('{}')
        os.exit(0)

    with open(TFSTATE_FILE) as f:
        tfstate = json.load(f)

    module = tfstate['modules'][0]

    etcd, etcd_hostvars = get_etcd_hosts(module)

    inventory = {
        'etcd': etcd,
        '_meta': {
            'hostvars': {}
        }
    }

    inventory['_meta']['hostvars'].update(etcd_hostvars)

    print(json.dumps(inventory))
