# Mozaik Dashboard
The [Mozaik Dashboard](http://mozaik.rocks/) provides an adaptive and extendable dashboard as central starting point for the Podium Collaboration Space.

The OpenShift deployment is straightforward, using the S2I nodejs deployment image.

One central configuration file determines the arrangement and content of the Mozaik widgets.
The configuration file is managed by OpenShift as a ConfigMap and can be modified and adapted as needed. After such modifications, the currently running Podium Pod needs to be deleted in order to be replaced with a new one reflecting the configuration changee.

In our configuration, we mainly use the [mozaik-ext-embed](https://github.com/juhamust/mozaik-ext-embed) extension for Mozaik, that allows to embed arbitrary HTML markup into the widget.

For demo purpose, we also use the [mozaik-ext-githug](https://github.com/plouc/mozaik-ext-github) extension to show how such an extension can be used to integrate the dashboard much deeper into the associated applications using the specific APIs. As ToDo for the Podium project, we want to create such Mozaik extensions to register new EtherPad Sketch Boards and provide automatic integration into the Mattermost Chat application.

## Lets Encrypt Certificate
The Podium Dashboard has not yet been configured to use HTTPS encryption.

ToDo:
[Setup Lets Encrypt on OpenShift](https://keithtenzer.com/2020/04/03/openshift-application-certificate-management-with-lets-encrypt/)

## Label Node
The Podium Dashboard is not dependent on specific node features.

### Create a new project

We expect all applications of the Podium Collaboration Space to be grouped into one OpenShift project. The name of the project is arbitrary and may reflect the theme or purpose of collaboration. If more than one Podium Space needs to be deployed in the same OpenShift cluster, the project name should be augmentd by a random identifier (GID).

```$ oc new-project podium-de4a```

### Create Mozaik Dashboard App
The Mozaik application is created using the S2I feature of OpenShift. We simply point OpenShift to the /mozaik/dashboard source directory and leave the rest to OpenShift.

```$ oc new-app https://github.com/sa-mw-dach/podium.git --context-dir=/mozaik/dashboard/ --strategy=source```

### Customize the Dashboard
The Dashboard with all widgets are configured in one single configuration file [config.js](dashboard/config.js)

In order to make the Dashboard universally usable for many different use cases, we replace this configuration file with a ConfigMap in OpenShift.

The provided template gives an example. It is important that the generated URLs match the setup to connect the dashboard with the other application.

```oc process --parameters -f configmap-template.yaml```
```oc process  -f configmap.yaml -p NAMESPACE=jitsi |oc create -f -```

In order to activate the ConfigMap we need to patch the Deployment Config created in the previous step and we need to start the rollout of that new configuration.

```oc patch deploymentconfig podium -p '{"spec":{"template":{"spec":{"containers":[{"name":"podium","volumeMounts":[{"mountPath":"/opt/app-root/src/config.js","name":"dashboard-config","subPath":"config.js"}]}],"volumes":[{"configMap":{ "defaultMode":420,"items":[{"key":"hackathon-conf","path":"config.js"}],"name":"mozaik-config" },"name":"dashboard-config"}]}}}}'```

```$ oc rollout latest dc/podium```


### Access Mozaik Dashboard
The deployment does not expose the service automatically, so we finish our installation with these steps.

```$ oc expose svc/podium```
```$ oc get route```
