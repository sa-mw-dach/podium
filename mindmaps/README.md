# Mindmaps
An open source, offline capable, mind mapping application leveraging HTML5 technologies.

## Deploy Mindmaps on OpenShift
You can use the provided Dockerfile to build a new mindmaps container image and application or you can use the provided YAML template and use the quay.io/podium/mindmaps image.

### Create a new project

```$ oc new-project mindmaps```

### Template Default Parameters
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.

```$ oc process --parameters -f mindmaps_template.yaml```

### Deploy Etherpad template

```$ oc process -f mindmaps_template.yaml -p APPLICATION_DOMAIN=apps.cloud.example.com -p NAMESPACE=podium |oc create -f -```
