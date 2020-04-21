# Podium Operator
The podium operator will mange the deployment of podium environments accross the k8s cluster.

## Label node where you want the Jitsi Video Bridge to run
The video bridge is required for video conferencing. Video and audio from clients are sent to the jitsi video bridge (jvb) via a UDP connection. The node running the jvb must have an internet or routable IP than can be reached from participants. Currently this is done by exposing a node port. The jvb service uses a STUN server to discover the routable IP so this is all dynamic. The deployment sets a nodeSelector so that the jvb pod will only run on nodes with a routable IP. You can label multiple nodes as well, as long as they have a routable IP.

```$ oc label node ocp4-n4krq-worker-v996z app=jvb```

## Install Podium Operator
The Podium Operator supports the scope of cluster or namespace. Simply change the path to CRD and yaml files to cluster (cluster scope) or namespace (namespace scope). 

When running in scope namespace, the operator and instance of podium will run in same project. The cluster namespace allows using a single podium operator and can deploy/manage podium instances accross the cluster.

### Create Namespace
This is only required for running operator in a cluster scope. If running in namespace scope just create
the project as you would for running the podium instance below.

```$ oc new-project podium-operator```

### Create Podium CRD
Choose cluster or namespace directory under deploy depending on scope.

```$ oc create -f podium-operator/deploy/cluster/crds/podium.com_podia_crd.yaml```

### Create Podium Service Account
Choose cluster or namespace directory under deploy depending on scope.

```$ oc create -f podium-operator/deploy/cluster/service_account.yaml```

### Create Podium Cluster Role
Choose cluster or namespace directory under deploy depending on scope.

```$ oc create -f podium-operator/deploy/cluster/role.yaml```

### Create Podium Operator Cluster Role Binding
Choose cluster or namespace directory under deploy depending on scope.

```$ oc create -f podium-operator/deploy/cluster/role_binding.yaml```

### Deploy Podium Operator
Choose cluster or namespace directory under deploy depending on scope.

```$ oc create -f podium-operator/deploy/cluster/operator.yaml```

# Deploy Instance of Podium using Operator

## Create New Project for Podium Instance
If running operator as scope namespace you already created this project so this step can be skipped.

```$ oc new-project podium```

### Instantiate Podium Instance using Operator

```
$ vi podium.yaml
apiVersion: podium.com/v1alpha1
kind: Podium
metadata:
  name: mypodium
spec:
  mozaik_application_name: mozaik
  jitsi_application_name: jitsi
  etherpad_application_name: etherpad
  wekan_application_name: wekan
  mattermost_application_name: mattermost-team-edition
  dokuwiki_application_name: dokuwiki
  drawio_application_name: drawio
  application_domain: apps.ocp4.keithtenzer.com
  namespace: podium-dev
  etherpad_default_title: "Welcome to Etherpad"
  etherpad_default_text: "TEST TEST 1 2 3"
  mysql_user_password: <password>
  mysql_root_password: <password>
  mongo_database_name: wekan
  mongo_database_user: wekan
  mongo_database_password: <password>
  mongo_admin_password: <password>
  jicofo_component_secret: s3cr3t
  jicofo_auth_user: focus
  jicofo_auth_password: <password>
  jvb_auth_user: jvb
  jvb_auth_password: <password>
  jvb_brewery_muc: jvbbrewery
  jvb_tcp_harvester_disabled: 'true'
  jvb_enable_apis: rest
  jvb_stun_servers: meet-jit-si-turnrelay.jitsi.net:443
  timezone: Europe/Berlin
  jvb_node_port: 30000
  jvb_node_selector: jitsi
```

```$ oc create -f podium.yaml```

### Delete Podium Operator

```$ oc delete project podium-operator
$ oc delete crd/podia.podium.com
$ oc delete clusterrole/podium-operator
$ oc delete clusterrolebinding/podium-operator
```
