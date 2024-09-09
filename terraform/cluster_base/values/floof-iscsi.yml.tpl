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
        # get the correct ID from the "portal" section in the UI
        # https://github.com/democratic-csi/democratic-csi/issues/302
        # NOTE: the ID in the UI does NOT always match the ID in the DB, you must use the DB value
        - targetGroupPortalGroup: 1
          # get the correct ID from the "initiators" section in the UI
          targetGroupInitiatorGroup: 1
          # None, CHAP, or CHAP Mutual
          targetGroupAuthType: None
          # get the correct ID from the "Authorized Access" section of the UI
          # only required if using Chap
          targetGroupAuthGroup:

      extentCommentTemplate: "{{ parameters.[csi.storage.k8s.io/pvc/namespace] }}/{{ parameters.[csi.storage.k8s.io/pvc/name] }}"
      extentInsecureTpc: true
      extentXenCompat: false
      extentDisablePhysicalBlocksize: true
      extentBlocksize: 512
      extentRpm: ""
      extentAvailThreshold: 0

csiDriver:
  name: floof-iscsi-csi

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
