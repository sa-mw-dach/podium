# Mattermost
A lightweight, opensource, self-hosted chat service for team collaboration. Provides file sharing, search and integration with many CI/CD tooling.

## Deploy Mattermost on OpenShift
Currently the mattermost deployment is using init containers. This of course provides more control and flexibility however also requires elevated permissions.


### Create a new project

```$ oc new-project mattermost```

### Allow init containers to start in project

```oc adm policy add-scc-to-user anyuid -z default```

### Template Default Parameters
OpenShift templates allow you to parameterize and automate deployment of all application components. Similar to helm charts.

```$ oc process --parameters -f jitis_meet_template.yaml```

### Deploy Etherpad template

```$ oc process -f mattermost_template.yaml |oc create -f -```
