# Podium
![](docs/images/podium_logo.png)

Communication is the key to any high performing team. Podium is a containerized deployment of a set of leading opensource communication tools that allow teams interact more effectively in a remote (post COVID-19) world. Podium brings tools together in a way that that allows not only a team to interact better but even more inportantly allows non-team members to interact effectively. Podium current provides the following components:
* [Dashboard (Mozaik)](http://mozaik.rocks/)
* [Chat (Mattermost)](https://mattermost.com/)
* [Video Conferencing (Jitsi Meet)](https://jitsi.org/jitsi-meet/)
* [Real-time Document Editing (Etherpad)](https://etherpad.org/)
* [Diagram Drawing (Drawio)](https://github.com/jgraph/drawio)
* [Wiki (Dokuwiki)](https://www.dokuwiki.org/dokuwiki)
* [Kanban Board (Wekan)](https://github.com/wekan/wekan)

An instance of podium will deploy all components and configure a dashboard so all team and non-team members can interact immediately as well as effectively.

![](docs/images/podium_demo.PNG)

## Feature requests
If you would like to see a feature or addition please open a issue and feel welcome to contribute.

## Pre-requisites
* OpenShift or Kubernetes environment
* Public or rotable IP on at least one node.
* Port 30000 or whatever the jvb node port is on UDP needs to be open to public or routable IP.
* Port 3478 TCP/UDP needs to be open to public or routable IP.
* TLS certificate solution like Let's Encrypt.

## Lets Encrypt Certificate
Podium requires proper TLS certificates. For lets encrypt solution, TLS should be terminated on the edge of the OpenShift route or kubermetes ingres. Podium will automatically deploy OpenShift routes with edge termination and dynamically configure certificates using lets encrypt. You can of course configure your own routes or ingres.

[Setup Lets Encrypt on OpenShift](https://keithtenzer.com/2020/04/03/openshift-application-certificate-management-with-lets-encrypt/)

## Deployment
You can deploy Podium using [Podium Operator](podium-operator/README.md) for OpenShift 4 or [Deployment Templates](docs/TEMPLATE_DEPLOYMENT.md) for OpenShift 3/4.
