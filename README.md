# Podium
Communication is the key to any high performing team. Podium is a containerized deployment of a set of opensource communication tools that allow DevOps teams interact more effectively in a remote (post COVID-19) world. Podium current provides the following components:
* [Video Conferencing (Jitsi Meet)](https://jitsi.org/jitsi-meet/)
* [Real-time Document Editing (Etherpad)](https://etherpad.org/)

Etherpad is also seamlessly integrated directly into Jitsi meet providing a shared document for each meeting that participants can access in real-time.

## Lets Encrypt Certificate
Jitsi meet requires a TLS certificate. TLS can be terminated inside the web pod or terminated on the edge. I would recommend edge termination and in this case we can use a lets encrypt k8s admission controller to setup our certificates within the created OpenShift route.

[Setup Lets Encrypt on OpenShift](https://keithtenzer.com/2020/04/03/openshift-application-certificate-management-with-lets-encrypt/)

## Deployment
The plan is to move toward an operator for deploying and managing Podium components. Currently OpenShift templates are provided that create the necessary k8s objects. Templates just provide a way to parameterize k8s objects as such the objects can be pulled out of the template and intantiated individually for non-OpenShift k8s environments.

### Create New Project

```$ oc create new-project podium```

### Deploy Etherpad

```$ oc process -f etherpad_template.yaml |oc create -f -```

### Deploy Jitsi Meet
```$ oc process -f jitsi_meet_template.yaml -p APPLICATION_DOMAIN=jitsi-<namespace>.<wildcard domain> -p TIMEZONE=Europe/Berlin |oc create -f -```

### Access environment
The template will create a default https route (edge termination) for jitsi and etherpad. Assuming you configured the lets encrypt admission controller, the certificate will automatically be added to your routes. It can take several minutes for the lets encrypt certificate to be issues so be patient.

```
$ oc get routes
NAME       HOST/PORT                                   PATH   SERVICES   PORT   TERMINATION   WILDCARD
etherpad   etherpad-podium.apps.ocp4.keithtenzer.com          etherpad   9001   edge          None
jitsi      jitsi-podium.apps.ocp4.keithtenzer.com             web        http   edge          None
```

You can access jitsi meet using https://jitsi-podium.apps.ocp4.keithtenzer.com for example.
