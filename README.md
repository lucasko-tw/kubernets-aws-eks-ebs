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

### Deployment

```
apiVersion: apps/v1beta2 # for kubectl versions >= 1.9.0 use apps/v1
kind: Deployment
metadata:
  name: test-mysql-deployment
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test-mysql-app
  template:
    metadata:
      labels:
        app: test-mysql-app
    spec:
      containers:
        - image: mysql:5.6
          name: mysql
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: "123456789"
            - name: MYSQL_DATABASE
              value: "mydb"
          ports:
            - containerPort: 3306
              name: mysql
          volumeMounts:
            - name: mysql-persistent-storage
              mountPath: /var/lib/mysql
      volumes:
        - name: mysql-persistent-storage
          persistentVolumeClaim:
            claimName: test-pvc
```

```
kubectl apply -f test-mysql-deployment.yml
```
