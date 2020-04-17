# Wekan 
Wekan is an open Source Kanban board

## Deploy Wekan on OpenShift



### Create a new project

We expect all applications of the Podium Collaboration Space to be grouped into one OpenShift project. The name of the project is arbitrary and may reflect the theme or purpose of collaboration. If more than one Podium Space needs to be deployed in the same OpenShift cluster, the project name should be augmentd by a random identifier (GID).

```$ oc new-project podium-de4a```

### Template Default Parameters
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.

```$ oc process --parameters -f wekan_template.yaml```

### Deploy Etherpad template

```$ oc process -f wekan_template.yaml -p APPLICATION_DOMAIN=apps.ocp4.keithtenzer.com -p NAMESPACE=podium |oc create -f -```
