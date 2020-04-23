# Pre-requisites
* Public or rotable IP on at least one node.
* Port 30000 or whatever the jvb node port is on UDP needs to be open to public or routable IP.
* Port 3478 TCP/UDP needs to be open to public or routable IP.
* TLS certificate solution like Let's Encrypt.

# Create New Project

```$ oc create new-project podium```

# Deploy Mattermost

```$ oc process -f mattermost/yaml/mattermost_template.yaml -p APPLICATION_DOMAIN=apps.cloud.example.com -p NAMESPACE=podium |oc create -f -```

# Deploy Etherpad

```$ oc process -f etherpad/yaml/etherpad_template.yaml -p APPLICATION_DOMAIN=apps.cloud.example.com -p NAMESPACE=podium |oc create -f -```

# Deploy Jitsi Meet
```$ oc process -f jitsi/yaml/jitsi_meet_template.yaml -p TIMEZONE=Europe/Berlin -p APPLICATION_DOMAIN=apps.cloud.example.com -p NAMESPACE=podium |oc create -f -```

# Deploy DokuWiki

```$ oc new-app https://github.com/splitbrain/dokuwiki.git --strategy=source```

```$ oc expose svc/dokuwiki```

# Deploy Mozaik Dashboard

```$ oc new-app https://github.com/sa-mw-dach/podium.git --context-dir=/mozaik/dashboard/ --strategy=source```

```$ oc patch deploymentconfig podium -p '{"spec":{"template":{"spec":{"containers":[{"name":"podium","volumeMounts":[{"mountPath":"/opt/app-root/src/config.js","name":"dashboard-config","subPath":"config.js"}]}],"volumes":[{"configMap":{ "defaultMode":420,"items":[{"key":"hackathon-conf","path":"config.js"}],"name":"mozaik-config" },"name":"dashboard-config"}]}}}}'```

```$ oc rollout latest dc/podium```

```$ oc expose svc/podium```


# Access environment
The template will create a default https route (edge termination) for jitsi and etherpad. Assuming you configured the lets encrypt admission controller, the certificate will automatically be added to your routes. It can take several minutes for the lets encrypt certificate to be issues so be patient.

```
$ oc get routes
NAME       HOST/PORT                                   PATH   SERVICES                  PORT   TERMINATION   WILDCARD
chat       chat-podium.apps.cloud.example.com              mattermost-team-edition   8065   edge          None
etherpad   etherpad-podium.apps.cloud.example.com          etherpad                  9001   edge          None
meet       meet-podium.apps.cloud.example.com              web                       http   edge          None
```

You can access jitsi meet using https://meet-podium.apps.ocp4.keithtenzer.com for example.

You can access the Mozaik Dashboard using http://podium-dashboard-jitsi.apps.cloud.lunetix.org/ for another example.
