driver:
  config:
    driver: freenas-api-nfs
    instance_id:
    httpConnection:
      protocol: http
      host: 10.0.3.1
      port: 80
      apiKey: ${api_key}
      allowInsecure: true
    zfs:
      datasetProperties:
        "org.freenas:description": "{{ parameters.[csi.storage.k8s.io/pvc/namespace] }}/{{ parameters.[csi.storage.k8s.io/pvc/name] }}"

      datasetParentName: jabberwock/object/vol
      detachedSnapshotsDatasetParentName: jabberwock/object/snap
      zvolCompression: ""
      zvolDedup: ""
      datasetEnableQuotas: true
      zvolEnableReservation: false
      zvolBlocksize: 16K
    nfs:
      shareHost: 10.0.3.1
      shareAlldirs: false
      shareAllowedHosts: []
      shareAllowedNetworks: []
      shareMaprootUser: root
      shareMaprootGroup: root
      shareMapallUser: ""
      shareMapallGroup: ""

csiDriver:
  name: jabberwock-nfs-csi

storageClasses:
  - name: jabberwock-nfs-csi
    defaultClass: false
    reclaimPolicy: Delete
    volumeBindingMode: Immediate
    allowVolumeExpansion: true
    mountOptions: [nfsvers=4.1, async, nodiratime, noatime]
    parameters:
      fsType: nfs
    secrets:
      provisioner-secret:
      controller-publish-secret:
      node-stage-secret:
      node-publish-secret:
      controller-expand-secret:
