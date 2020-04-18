# DokuWiki
[DokuWiki](https://www.dokuwiki.org/) is an easy to use Wiki to share information and build an instant knowledge base for your projet.

The OpenShift deployment is straightforward, using the S2I nodejs deployment image.

### Label Node
The DokuWiki is not dependent on specific node features.

### Create a new project

We expect all applications of the Podium Collaboration Space to be grouped into one OpenShift project. The name of the project is arbitrary and may reflect the theme or purpose of collaboration. If more than one Podium Space needs to be deployed in the same OpenShift cluster, the project name should be augmentd by a random identifier (GID).

If you start your deployment with the DokuWiki, you need to create that new project. Otherwise you simply use the existing project together with the other Podium applications.

```$ oc new-project podium-de4a```

### Create DokuWiki
The DokuWiki application is created using the S2I feature of OpenShift. We simply point OpenShift to the upstream project source directory and leave the rest to OpenShift.

```$ oc new-app https://github.com/splitbrain/dokuwiki.git --strategy=source```

### Access DokuWiki
The deployment does not expose the service automatically, so we finish our installation with these steps.

```$ oc expose svc/dokuwiki```

```$ oc get route```

### Configure TLS Security

Patch route object to enable ACME TLS endpoint termination.

```$ oc patch route dokuwiki -p '{
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

### Initialize DokuWiki

DokuWiki does not use a database backend nor do we use a persistent volume to save the Wiki content. That makes the knowledge base ephemeral. We intentionally take that approach, because we do not want to make the deployment depending on the reliability and longevity of a particular OpenShift cluster. Our own OpenShift clusters are subject of constant turnover and we do not want to make our own Podium projects depend on one such cluster.

Instead, we want the DokuWiki to be linked to a doc/wiki folder in our main Git project. We initialize the DokuWiki from that directory and we regularly commit changes in our Podium DokuWiki back to the main Git.

```POD=dokuwiki-6d8d7cb575-bqdpk
oc rsh $POD git clone https://github.com/sa-mw-dach/podium.git project
oc rsh $POD /bin/sh -c "cp -r project/doc/wiki/* data/pages"
```

ToDo: Examine means to use DokuWiki API to clone content from Git into the application container

