# Install Podium Operator Using OLM
The Operator lifecycle manager comes built-in with OpenShift. It enables lifecyle management of an operator. In order to use OLM you need to package your operator and create a catalog that contains your operator bundle. To use the podium operator through OLM simply create a catalog source, pointing to the podium operator index bundle. Make sure it is created in the openshift-marketplace
namespace or the namespace that is running OLM.

## Create Catalog Source for Podium Operator

```
$ vi catalogsource.yaml
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: podium-operator-catalog
spec:
  sourceType: grpc
  image: quay.io/ktenzer/podium-operator-index:1.0.0
  displayName: Podium Operator Catalog
  publisher: Podium Community
```

```$ oc create -f catalogsource.yaml -n openshift-marketplace```

# Install Podium Operator Manually
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

```$ oc create new-project podium```

## Label Node you want to run jvb service (video bridge)

```$ oc label node ocp4-n4krq-worker-v996z app=jvb```

## Create Podium CR

```
$ vi podium.yaml
kind: Podium
metadata:
  name: mypodium
spec:
  application_domain: <apps wildcard domain>
  namespace: <namespace>
  jvb_node_port: 30000
  etherpad:
    enable: true
    application_name: etherpad
    default_title: "Welcome to Etherpad"
    default_text: "Etherpad is a real-time text editor"
  jitsi:
    enable: true
    application_name: jitsi
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
    jvb_node_selector: jitsi
  mattermost:
    enable: true
    application_name: mattermost-team-edition
    mysql_user_password: <password>
    mysql_root_password: <password>
  wekan:
    enable: true
    application_name: wekan
    mongo_database_name: wekan
    mongo_database_user: wekan
    mongo_database_password: <password>
    mongo_admin_password: <password>
  drawio:
    enable: true
    application_name: drawio
  dokuwiki:
    enable: true
    application_name: dokuwiki
  mozaik:
    enable: true
    application_name: mozaik
```

## Apply Podium CR
```$ oc apply -f podium.yaml```

# Access environment
The template will create a default https route (edge termination) for jitsi and etherpad. Assuming you configured the lets encrypt admission controller, the certificate will automatically be added to your routes. It can take several minutes for the lets encrypt certificate to be issues so be patient.

```
$ oc get routes
NAME       HOST/PORT                                       PATH   SERVICES                  PORT   TERMINATION   WILDCARD
chat       chat-podium.apps.ocp4.keithtenzer.com                  mattermost-team-edition   8065   edge          None
dokuwiki   dokuwiki-podium.apps.ocp4.keithtenzer.com              dokuwiki                  8080   edge          None
drawio     drawio-podium.apps.ocp4.keithtenzer.com                drawio                    8080   edge          None
etherpad   etherpad-podium.apps.ocp4.keithtenzer.com              etherpad                  9001   edge          None
meet       meet-podium.apps.ocp4.keithtenzer.com                  web                       http   edge          None
mozaik     podium-podium.apps.ocp4.keithtenzer.com                mozaik                    8080                 None
wekan      wekan-podium.apps.ocp4.keithtenzer.com                 wekan                     8080   edge          None
```

You can access jitsi meet using https://meet-podium.apps.ocp4.keithtenzer.com for example.

You can access the Mozaik Dashboard using http://podium-dashboard-jitsi.apps.cloud.lunetix.org/ for another example.
