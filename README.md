# Podium
Communication is the key to any high performing team. Podium is a containerized deployment of a set of leading opensource communication tools that allow teams interact more effectively in a remote (post COVID-19) world. Podium brings tools together in a way that that allows not only a team to interact better but even more inportantly allows non-team members to interact effectively. Podium current provides the following components:
* [Dashboard (Mozaik)](http://mozaik.rocks/)
* [Chat (Mattermost)](https://mattermost.com/)
* [Video Conferencing (Jitsi Meet)](https://jitsi.org/jitsi-meet/)
* [Real-time Document Editing (Etherpad)](https://etherpad.org/)

An instance of podium will deploy all components and configure a dashboard so all team and non-team members can interact immediately as well as effectively.

## Feature requests
If you would like to see a feature or addition please open a issue and feel welcome to contribute.

## Lets Encrypt Certificate
Jitsi meet requires a TLS certificate. TLS can be terminated inside the web pod or terminated on the edge. I would recommend edge termination and in this case we can use a lets encrypt k8s admission controller to setup our certificates within the created OpenShift route.

[Setup Lets Encrypt on OpenShift](https://keithtenzer.com/2020/04/03/openshift-application-certificate-management-with-lets-encrypt/)

## Deployment
The plan is to move toward an operator for deploying and managing Podium components. Currently OpenShift templates are provided that create the necessary k8s objects. Templates just provide a way to parameterize k8s objects as such the objects can be pulled out of the template and intantiated individually for non-OpenShift k8s environments.

### Create New Project

```$ oc create new-project podium```

### Allow anyuid in namespace
This is something we will be improving but for now, mattermost requires init containers that require elevated permissions

```$ oc adm policy add-scc-to-user anyuid -z default```

### Deploy Mattermost

```$ oc process -f mattermost/yaml/mattermost_template.yaml -p APPLICATION_DOMAIN=apps.ocp4.keithtenzer.com -p NAMESPACE=podium |oc create -f -```

### Deploy Etherpad

```$ oc process -f etherpad/yaml/etherpad_template.yaml -p APPLICATION_DOMAIN=apps.ocp4.keithtenzer.com -p NAMESPACE=podium |oc create -f -```

### Deploy Jitsi Meet
```$ oc process -f jitsi/yaml/jitsi_meet_template.yaml -p TIMEZONE=Europe/Berlin -p APPLICATION_DOMAIN=apps.ocp4.keithtenzer.com -p NAMESPACE=podium |oc create -f -```

### Access environment
The template will create a default https route (edge termination) for jitsi and etherpad. Assuming you configured the lets encrypt admission controller, the certificate will automatically be added to your routes. It can take several minutes for the lets encrypt certificate to be issues so be patient.

```
$ oc get routes
NAME       HOST/PORT                                   PATH   SERVICES                  PORT   TERMINATION   WILDCARD
chat       chat-podium.apps.ocp4.keithtenzer.com              mattermost-team-edition   8065   edge          None
etherpad   etherpad-podium.apps.ocp4.keithtenzer.com          etherpad                  9001   edge          None
meet       meet-podium.apps.ocp4.keithtenzer.com              web                       http   edge          None
```

You can access jitsi meet using https://meet-podium.apps.ocp4.keithtenzer.com for example.
