### EKS: EBS Volume

Create EBS using awscli.

```sh

aws ec2 create-volume --region eu-west-1 --availability-zone eu-west-1a --size 11 --volume-type gp2


{
    "AvailabilityZone": "eu-west-1a",
    "Tags": [],
    "Encrypted": false,
    "VolumeType": "gp2",
    "VolumeId": "vol-000183c73c4da3963",
    "State": "creating",
    "Iops": 100,
    "SnapshotId": "",
    "CreateTime": "2019-04-02T13:46:10.000Z",
    "Size": 11
}
```

> VolumeId will be used later.

Create a new PersistentVolume file.

```sh
vim test-pv.yml
```

Update the **volumeID** and **storage size** to match size of previous command.

```sh
kind: PersistentVolume
apiVersion: v1
metadata:
  name: test-pv
  labels:
    type: amazonEBS
spec:
  capacity:
    storage: 11Gi
  accessModes:
    - ReadWriteOnce
  awsElasticBlockStore:
    volumeID: <your-volume-id>
    fsType: ext4
```
> Making sure the storage is matching.
>
> volumeID should be matched.


Apply PersistentVolume on EKS.

```sh
kubectl create -f test-pv.yml
```

Check result.

```sh
kubectl get pv
```

Create a new PersistentVolumeClaim file.

```sh
vim test-pvc.yml
```

```sh
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-pvc
  labels:
    type: amazonEBS
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 11Gi
```

Apply PersistentVolumeClaim on EKS.

```sh
kubectl create -f test-pvc.yml
```

Check result.

```sh
kubectl get pvc
```
