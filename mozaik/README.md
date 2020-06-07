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

### Create Mozaik Dashboard App using source strategy
The Mozaik application is created using the S2I feature of OpenShift. We simply point OpenShift to the /mozaik/dashboard source directory and leave the rest to OpenShift.

```$ oc new-app https://github.com/sa-mw-dach/podium.git --context-dir=/mozaik/dashboard/ --strategy=source```

### Customize the Dashboard with source strategy
The Dashboard with all widgets are configured in one single configuration file [config.js](dashboard/config.js)

In order to make the Dashboard universally usable for many different use cases, we replace this configuration file with a ConfigMap in OpenShift.

The provided template gives an example.
As you can easily see, the config.js consists 

It is important that the generated URLs match the setup to connect the dashboard with the other application.

#### Using the ConfigMap with the source strategy deployment

```
$ oc process --parameters -f configmap_template.yaml
$ oc process  -f configmap_template.yaml -p NAMESPACE=jitsi |oc create -f -
```

In order to activate the ConfigMap we need to patch the Deployment Config created in the previous step and we need to start the rollout of that new configuration.

```$ oc patch deploymentconfig podium -p '{"spec":{"template":{"spec":{"containers":[{"name":"podium","volumeMounts":[{"mountPath":"/opt/app-root/src/config.js","name":"dashboard-config","subPath":"config.js"}]}],"volumes":[{"configMap":{ "defaultMode":420,"items":[{"key":"podium-conf","path":"config.js"}],"name":"mozaik-config" },"name":"dashboard-config"}]}}}}'```

```$ oc rollout latest dc/podium```

### Customize the Dashboard with Podium Operator

When you deploy the Podium with the Operator, you can still replace the default mozaik-config ConfigMap object with your own customized one. We describe that method later in this docusment.

The other way to customize your Mozaik Dashboard is to provide your custom parameters right away with the operator deployment.

Here is the list of parameters you can use to custimize:

Parameter Name | Parameter Description
--------------------------|--------------------------------------------------------------------------
meeting_title | The title displayed in the central video conference widget, replacing "Conference Center"
meeting_1_name | The alternative name for the first of the three conference room entries in the central video conference widget; also used as name and id for the first EtherPad and EtherDraw documents
meeting_1_url | The URL to the first of the three conference room entries in the central video conference widget. You may replace the Jitsi conference room here and use a link to your corporate video conferencing systems if you want to facilitate conferences with huge audiences that may exceed the limits of our Jitsi application.
meeting_1_image_url | The URL used in the `<img src/>` HTML tag for the first of the three conference room entries in the central video conference widget. You may want to use the application logo for your corporate video conferencing system if you choose to replace the first Jists conference room with the option above.
meeting_2_name | The alternative name for the second of the three conference room entries in the central video conference widget; also used as name and id for the second EtherPad and EtherDraw documents
meeting_2_url | The URL to the second of the three conference room entries in the central video conference widget. You may omit this entry and let the Podium Operator generate this for you, even if you are using a custom name for that room.
meeting_2_image_url | The URL used in the `<img src/>` HTML tag for the second of the three conference room entries in the central video conference widget. You may use any public source of images, such as [pixabay](https://pixabay.com). The image will automatically be scaled down to 300x200 pixels. When you choose a picture for your personal home office room, you can use this same image as background in your OBS scene setup.
meeting_3_name | Same as above, just for the third of the three conference rooms.
meeting_3_url | Same as above, just for the third of the three conference rooms.
meeting_3_image_url | Same as above, just for the third of the three conference rooms.
wiki_title  | The title displayed in the middle left column widget, replacing "Knowledge Base"
wiki_name | The alternative name for the middle left column link, replacing "DokuWiki"
wiki_url | The URL to your custom wiki application, replacing the internal Podium DokuWiki. If you replace DokuWiki in here, you may want to omit the deployment of the internal application by setting `enable: false` in the `dokuwiki:` section of the Podium parmeters set.
wiki_image_url | The URL used in the `<img src/>` HTML tag for the middle left column link.
productivity_tools_title | The title displayed in the bottom middle column widget, replacing "Productivity Tools"
draw_name |
draw_url |
draw_image_url |
kanban_name |
kanban_url |
kanban_image_url |
mindmaps_name |
mindmaps_url |
mindmaps_image_url |
chat_title |
chat_name |
chat_url |
chat_image_url |

Here is a complete example for the above described parameters. This example implements a Home Office setup of Podium using corporate tools we use within Red Hat. You may or may not be able to access these tools from the public internet.

```
  mozaik:
    meeting_title : "Red Hatter´s HomeOffice"
    meeting_1_name: "BlueJeans"
    meeting_1_url: "https://bluejeans.com/111"
    meeting_1_image_url: "https://images.saasworthy.com/bluejeans_5498_logo_1579759422_nayyu.jpg"
    meeting_2_name: "WorkPlace"
    meeting_2_url: "https://meet-{{ meta.namespace }}.{{ application_domain }}/WorkPlace"
    meeting_2_image_url: "https://cdn.pixabay.com/photo/2016/11/23/14/49/building-1853330_960_720.jpg"
    meeting_3_name: "ThinkTank"
    meeting_3_url: "https://meet-{{ meta.namespace }}.{{ application_domain }}/ThinkTank"
    meeting_3_image_url: "https://cdn.pixabay.com/photo/2017/02/22/21/06/fractal-2090592_960_720.jpg"
    wiki_title : "{{ mozaik.custom_wiki_title if mozaik.custom_wiki_title is defined else 'Knowledge Base' }}"
    wiki_name: "{{ mozaik.custom_wiki_url if mozaik.custom_wiki_url is defined else 'Wiki' }}"
    wiki_url: "{{ mozaik.custom_wiki_name if mozaik.custom_wiki_name is defined else 'https://dokuwiki-{{ meta.namespace }}.{{ application_domain }}' }}"
    wiki_image_url: "{{ mozaik.custom_wiki_image_url if mozaik.custom_wiki_image_url is defined else 'https://www.dokuwiki.org/_media/wiki:dokuwiki-128.png' }}"
    productivity_tools_title: "{{ mozaik.custom_productivity_tools_title if mozaik.custom_productivity_tools_title is defined else 'Productivity Tools' }}"
    draw_name: "{{ mozaik.custom_draw_name if mozaik.custom_draw_name is defined else 'Draw.io' }}"
    draw_url: "{{ mozaik.custom_draw_url if mozaik.custom_draw_url is defined else 'https://drawio-{{ meta.namespace }}.{{ application_domain }}' }}"
    draw_image_url: "{{ mozaik.custom_draw_image_url if mozaik.custom_draw_image_url is defined else 'https://cdn.worldvectorlogo.com/logos/draw-io.svg' }}"
    kanban_name: "SmartSheet"
    kanban_url: "https://app.smartsheet.com/b/orgsso/12345123451234512345123434"
    kanban_image_url: "https://www.qbssoftware.com/image/cache/catalog/qbs/smartsheet-550x550.png"
    mindmaps_name: "{{ mozaik.custom_mindmaps_name if mozaik.custom_mindmaps_name is defined else 'Mindmaps' }}"
    mindmaps_url: "{{ mozaik.custom_mindmaps_url if mozaik.custom_mindmaps_url is defined else 'https://mindmaps-{{ meta.namespace }}.{{ application_domain }}' }}"
    mindmaps_image_url: "{{ mozaik.custom_mindmaps_image_url if mozaik.custom_mindmaps_image_url is defined else 'https://raw.githubusercontent.com/sa-mw-dach/podium/master/docs/images/mindmap.png' }}"
    chat_title: "{{ mozaik.custom_chat_title if mozaik.custom_chat_title is defined else 'Chat' }}"
    chat_name: "Google Chat"
    chat_url: "https://chat.google.com"
    chat_image_url: "https://www.lclark.edu/live/image/gid/8/width/300/height/600/78198_hangouts_chat_2.rev.1555350502.png"
```

### Access Mozaik Dashboard
The deployment does not expose the service automatically, so we finish our installation with these steps.

```
$ oc expose svc/podium
$ oc get route
```



