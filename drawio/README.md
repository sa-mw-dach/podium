# Draw.io
Draw.io is a online diagramming tool.

## Deploy Draw.io on OpenShift


### Create a new project

We expect all applications of the Podium Collaboration Space to be grouped into one OpenShift project. The name of the project is arbitrary and may reflect the theme or purpose of collaboration. If more than one Podium Space needs to be deployed in the same OpenShift cluster, the project name should be augmentd by a random identifier (GID).

```$ oc new-project podium-de4a```

### Template Default Parameters
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.

```$ oc process --parameters -f drawio_template.yaml```

### Deploy Draw.io template

```$ oc process -f drawio_template.yaml -p APPLICATION_DOMAIN=apps.cloud.example.com -p NAMESPACE=podium |oc create -f -```

### Configure TLS Security

Patch route object to enable ACME TLS endpoint termination.

```$ oc patch route drawio -p '{
    "metadata": {
        "annotations": {
            "kubernetes.io/tls-acme": "true"
        }
    },
    "spec": {
        "tls": {
            "termination": "edge"
        }
    }
}'
```

