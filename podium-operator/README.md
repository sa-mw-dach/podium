# Podium Operator
The podium operator will mange the deployment of podium environments accross the k8s cluster.

## Install Podium Operator

### Create Namespace

```$ oc new-project podium-operator```

### Create Podium CRD

```$ oc create -f podium-operator/deploy/crds/podium.com_podia_crd.yaml```

### Create Podium Service Account

```$ oc create -f podium-operator/deploy/service_account.yaml```

### Create Podium Cluster Role

```$ oc create -f podium-operator/deploy/role.yaml```

### Create Podium Operator Cluster Role Binding
```$ oc create -f podium-operator/deploy/role_binding.yaml```

### Deploy Podium Operator 
```$ oc create -f podium-operator/deploy/operator.yaml```

## Deploy Instance of Podium using Operator

### Create Namespace for Podium Instance

```$ oc new-project podium```
 
### Instantiate Podium Instance using Operator

```
$ vi podium.yaml
apiVersion: podium.com/v1alpha1
kind: Podium
metadata:
  name: podium
spec:
  size: 1
```

```$ oc create -f podium.yaml```

