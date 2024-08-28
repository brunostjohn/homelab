#!/usr/bin/env python
from kubernetes import client, config
import json

config.load_kube_config()
v1 = client.CoreV1Api()

result = {}
result['all'] = {}
result['all']['hosts'] = []
result['_meta'] = {"hostvars": {}}
for i in v1.list_node().items:
    vars = {
      "os": i.status.node_info.os_image,
      "unschedulable": i.spec.unschedulable,
      "pod_cidr": i.spec.pod_cidr,
      "external_id": i.spec.external_id,
      # "taints": i.spec.taints,
      "role": 'master' if 'node-role.kubernetes.io/master' in i.metadata.labels else 'worker',
      "kubelet_version": i.status.node_info.kubelet_version,
      "kernel_version": i.status.node_info.kernel_version,
      "hostname": i.metadata.labels['kubernetes.io/hostname'],
      "annotations": i.metadata.annotations
      }
    vars.update({addr.type: addr.address for addr in i.status.addresses})
    name = vars['Hostname']
    vars['ansible_ssh_host'] = vars['InternalIP']
    vars['ansible_hostname'] =  name
    result['_meta']['hostvars'][name] = vars
    result['all']['hosts'].append(name)
    if vars['role'] in result:
      result[vars['role']].append(name)
    else:
      result[vars['role']] = [name]


print(json.dumps(result))