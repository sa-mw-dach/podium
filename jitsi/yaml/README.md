# Jitsi Meet
A lightweight opensource video conferencing tool. Jitsi Meet has 4 service components: jicofo prosody web jvb. Currently we are using an all-in-one image that runs a single pod and these four services as containers within the pod. 

## Deploy Jitsi Meet on OpenShift
### Create a new project
```$ oc create new-project jitsi```

### Allow root permissions to jitsi project
Currently Jitsi container image runs as root, this is something we need to improve.
```$ oc adm policy add-scc-to-user anyuid -z default```

### Template Default Parameters
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.
```$ oc process --parameters -f jitis_meet_template.yaml
NAME                       DESCRIPTION                                        GENERATOR           VALUE
APPLICATION_NAME           the name and label for all components                                  jitsi
APPLICATION_DOMAIN         Application domain name used in route to service
TIMEZONE                   The default timezone                                                   America/Los_Angeles
JVB_STUN_SERVERS           Comma separated list of STUN servers (optional)
DOCKER_HOST_ADDRESS        IP or Hostname where Pod is running                                    localhost
XMPP_SERVER                XMPP Server                                                            localhost
XMPP_DOMAIN                XMPP Domain                                                            meet.jitsi
XMPP_AUTH_DOMAIN           XMPP Auth Domain                                                       auth.meet.jitsi
XMPP_INTERNAL_MUC_DOMAIN   XMPP Internal Muc Domain                                               internal-muc.meet.jitsi```

### Process Template
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.
```$ oc process -f jitsi_meet_template.yaml -p TIMEZONE=Europe/Berlin |oc create -f -```

### Access Jitsi Meet
The template will create a default https route (passthrough). Likely you may want to change or add your own route with a certificate.
Using http will also work but since Jitsi Meet is browser based you need to enable your browser to allow that which is not recommended.
```$ oc get route
NAME   HOST/PORT                              PATH   SERVICES   PORT    TERMINATION        WILDCARD
meet   meet-jitsi.apps.ocp4.keithtenzer.com          web        https   passthrough/None   None```