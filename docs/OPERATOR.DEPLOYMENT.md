# Deploy Podium Operator

## Create New Project for Operator

```$ oc create new-project podium-operator```

## Create Podium Operator CRD

```$ oc create -f podium-operator/deploy/crds/podium.com_podia_crd.yaml```

## Setup RBAC for Podium Operator

```$ oc create -f podium-operator/deploy/service_account.yaml```

```$ oc create -f podium-operator/deploy/role.yaml```

```$ oc create -f podium-operator/deploy/role_binding.yaml```

## Install Podium Operator

```$ oc create -f podium-operator/deploy/operator.yaml```

# Deploy Instance of Podium using Operator

## Create New Project for Podium Instance

```$ oc create new-project podium```

## Allow anyuid in namespace
This is something we will be improving but for now, mattermost requires init containers that require elevated permissions

```$ oc adm policy add-scc-to-user anyuid -z default```

## Create Podium CR

```
$ vi podium.yaml
kind: Podium
metadata:
  name: mypodium
spec:
  jitsi_application_name: jitsi
  etherpad_application_name: etherpad
  mattermost_application_name: mattermost-team-edition
  application_domain: <apps wildcard domain>
  namespace: podium-bla
  etherpad_default_title: "Welcome to Etherpad"
  etherpad_default_text: "Welcome to Etherpad, a real-time editor"
  mysql_user_password: <password>
  mysql_root_password: <password>
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
  jvb_node_selector: jvb
```

## Label Node you want to run jvb service (video bridge)

```$ oc label node ocp4-n4krq-worker-v996z app=jvb```

## Apply Podium CR
```$ oc apply -f podium.yaml```

# Access environment
The template will create a default https route (edge termination) for jitsi and etherpad. Assuming you configured the lets encrypt admission controller, the certificate will automatically be added to your routes. It can take several minutes for the lets encrypt certificate to be issues so be patient.

```
$ oc get routes
NAME       HOST/PORT                                   PATH   SERVICES                  PORT   TERMINATION   WILDCARD
chat       chat-podium.apps.cloud.example.com              mattermost-team-edition   8065   edge          None
etherpad   etherpad-podium.apps.cloud.example.com          etherpad                  9001   edge          None
meet       meet-podium.apps.cloud.example.com              web                       http   edge          None
```

You can access jitsi meet using https://meet-podium.apps.ocp4.keithtenzer.com for example.

You can access the Mozaik Dashboard using http://podium-dashboard-jitsi.apps.cloud.lunetix.org/ for another example.
