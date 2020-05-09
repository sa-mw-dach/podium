# Jitsi Meet
A lightweight opensource video conferencing tool. Jitsi Meet has 4 service components: jicofo prosody web jvb. Currently we are using an all-in-one image that runs a single pod and these four services as containers within the pod. 

Jitsi has two modes of communication peer-to-peer and video bridge. For meetings with more than two people the video bridge is required. When using the video bridge TCP/UDP connections will be made from the client (browser/app) to the JVB service. The node running the JVB service must have an public IP. In this configuration we are using a node port on the jvb service. The following ports must be open to the node running the jvb service:
* 30000 (TCP/UDP) JVB Service
* 3478 (TCP/UDP) Stun Server 

If you are having issues with video bridge, likely it is a firewall issue.

## Lets Encrypt Certificate
Jitsi meet requires a TLS certificate. TLS can be terminated inside the web pod or terminated on the edge. I would recommend edge termination and in this case we can use a lets encrypt k8s admission controller to setup our certificates within the created OpenShift route.

[Setup Lets Encrypt on OpenShift](https://keithtenzer.com/2020/04/03/openshift-application-certificate-management-with-lets-encrypt/)

## Label Node
For now all the jitsi components are deployed on the same OpenShift node. The template uses a node selector, so you need to label the node where you want to run the services.

```$ oc label nodes ocp4-n4krq-worker-wr668 app=jitsi```

## Deploy Jitsi Meet on OpenShift
### Create a new project

```$ oc create new-project jitsi```

### Template Default Parameters
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.

```$ oc process --parameters -f jitis_meet_template.yaml```

### Process Template
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.

```$ oc process -f jitsi_meet_template.yaml -p TIMEZONE=Europe/Berlin -p APPLICATION_DOMAIN=apps.cloud.example.com -p NAMESPACE=podium |oc create -f -```

### Access Jitsi Meet
The template will create a default https route (edge termination). Assuming you configured the lets encrypt admission controller, the certificate will automatically be added to your route. It can take several minutes for the lets encrypt certificate to be issues so be patient.

```$ oc get route```

## Build Jitsi Containers for OpenShift

The upstream project https://github.com/jitsi/docker-jitsi-meet for Jitsi Meet on Docker does not meet the requirements for containers running on OpenShift. In particular, the containers provided by the upstream project are running with root permissions.

Paul Tiedke has submitted a pull request to the upstream project that changes the containers to run without priviledges. This pull request has not been merged yet.

In order to build your own Jitsi containers for OpenShift with the most recent upstream versions of https://github.com/jitsi/docker-jitsi-meet, we provide the Paul Tiedke changes in one unified patch that is easy to apply to the upstream sources.

```
$ git clone https://github.com/jitsi/docker-jitsi-meet.git
$ cd docker-jitsi-meet
$ patch -p1 ../podium/jitsi/sapkra-ocp.patch
$ FORCE_REBUILD=1 make
$ podman images
```

In order to tag the newly created images and push them to the repository of your choice, you can use the tag-all and push-all Make targets for docker-jitsi-meet.

