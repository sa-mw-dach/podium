# Etherdraw
A lightweight, opensource, real-time collaborative drawing tool. Etherdraw allows multiple users to connect and simultaneously draw on a whiteboard canvas.

## Deploy Etherdraw on OpenShift
For now the deployment is using the built-in dirty db. We regard this as a feature because it keeps the deployment leight weight.

### Create a new project

```$ oc new-project etherdraw```

### Template Default Parameters
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.

```$ oc process --parameters -f etherdraw_template.yaml```

### Deploy Etherpad template

```$ oc process -f etherdraw_template.yaml -p APPLICATION_DOMAIN=apps.cloud.example.com -p NAMESPACE=podium |oc create -f -```
