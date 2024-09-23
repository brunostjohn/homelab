driver:
  config:
    driver: freenas-api-nfs
    instance_id:
    httpConnection:
      protocol: http
      host: 10.0.3.5
      port: 80
      apiKey: ${api_key}
      allowInsecure: true
    zfs:
      datasetProperties:
        "org.freenas:description": "{{ parameters.[csi.storage.k8s.io/pvc/namespace] }}/{{ parameters.[csi.storage.k8s.io/pvc/name] }}"

      datasetParentName: floofpool/object/vol
      detachedSnapshotsDatasetParentName: floofpool/object/snap
      zvolCompression: ""
      zvolDedup: ""
      datasetEnableQuotas: true
      zvolEnableReservation: false
      zvolBlocksize: 16K
    nfs:
      shareHost: 10.0.3.5
      shareAlldirs: false
      shareAllowedHosts: []
      shareAllowedNetworks: []
      shareMaprootUser: root
      shareMaprootGroup: root
      shareMapallUser: ""
      shareMapallGroup: ""

csiDriver:
  name: floof-nfs-csi

storageClasses:
  - name: floof-nfs-csi
    defaultClass: false
    reclaimPolicy: Delete
    volumeBindingMode: Immediate
    allowVolumeExpansion: true

    mountOptions: []
    secrets:
      provisioner-secret:
      controller-publish-secret:
      node-stage-secret:
      node-publish-secret:
      controller-expand-secret:
