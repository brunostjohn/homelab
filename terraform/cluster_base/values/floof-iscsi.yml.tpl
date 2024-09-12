driver:
  config:
    driver: freenas-api-iscsi
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

      datasetParentName: floofpool/block/vol
      detachedSnapshotsDatasetParentName: floofpool/block/snap
      zvolCompression: ""
      zvolDedup: ""
      zvolEnableReservation: false
      zvolBlocksize: 16K
    iscsi:
      targetPortal: 10.0.3.5:3260

      nameTemplate: "{{ parameters.[csi.storage.k8s.io/pvc/namespace] }}-{{ parameters.[csi.storage.k8s.io/pvc/name] }}"
      namePrefix: csi-
      nameSuffix: "-zefircluster"

      targetGroups:
        - targetGroupPortalGroup: 1
          targetGroupInitiatorGroup: 7
          targetGroupAuthType: None
          targetGroupAuthGroup:

      extentCommentTemplate: "{{ parameters.[csi.storage.k8s.io/pvc/namespace] }}/{{ parameters.[csi.storage.k8s.io/pvc/name] }}"
      extentInsecureTpc: true
      extentXenCompat: false
      extentDisablePhysicalBlocksize: true
      extentBlocksize: 512
      extentRpm: "SSD"
      extentAvailThreshold: 0

csiDriver:
  name: floof-iscsi-csi

node:
  driver:
    extraEnv:
      - name: PATH
        value: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin

storageClasses:
  - name: floof-iscsi-csi
    defaultClass: false
    reclaimPolicy: Delete
    volumeBindingMode: Immediate
    allowVolumeExpansion: true
    parameters:
      fsType: ext4

    mountOptions: []
    secrets:
      provisioner-secret:
      controller-publish-secret:
      node-stage-secret:
      node-publish-secret:
      controller-expand-secret:
