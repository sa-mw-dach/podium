# Podium
![](docs/images/podium_logo.png)

Communication is the key to any high performing team. Podium is a containerized deployment of a set of leading opensource communication and collaboration tools that allow teams interact more effectively in a remote (post COVID-19) world. Podium brings tools together in a way that that allows not only a team to interact better but even more importantly attempts to re-create the incidental interactions so lacking in a virtual-only world. All those watercooler, breakroom encounters we thought were a waste of time, were critical to our productivity. Podium not only promotes incidental interactions virtually but also allows team stakeholders or external members to better interact with teams. Podium takes a team approach to collaboration instead of an organizational approach. Podium currently provides the following components:
* [Dashboard (Mozaik)](http://mozaik.rocks/)
* [Video Conferencing (Jitsi Meet)](https://jitsi.org/jitsi-meet/)
* [Chat (Mattermost)](https://mattermost.com/)
* [Real-time Document Editing (EtherPad)](https://etherpad.org/)
* [Real-time Image Drawing (EtherDraw)](https://github.com/JohnMcLear/draw)
* [Wiki (Dokuwiki)](https://www.dokuwiki.org/dokuwiki)
* [Diagram Drawing (Drawio)](https://github.com/jgraph/drawio)
* [Kanban Board (Wekan)](https://github.com/wekan/wekan)
* [Mindmaps](https://github.com/drichard/mindmaps)

[Podium Introduction Video and Demo](https://youtu.be/ZqHwEURHfJY)

An instance of podium will deploy all components and configure a dashboard so all team and non-team members can interact immediately as well as effectively. Onboarding a new team member is self explanatory.

![](docs/images/podium_demo.PNG)

## Feature requests
If you would like to see a feature or addition please open a issue and feel welcome to contribute.

## Pre-requisites
* OpenShift environment
* Public or routable IP exists on node running the jvb (jitsi video bridge) pod.
* Port 30000 TCP/UDP ingress must be open on the node running the jvb pod.
* Port 3478 TCP/UDP egress must be open for from jvb node to STUN server.
* Ports 5347 TCP, 5222 TCP and 5280 TCP ingress must be open on all nodes running jitsi pods jvb, jicofo, prosody and web.
* TLS certificate solution like Let's Encrypt.

## Lets Encrypt Certificate
Podium requires proper TLS certificates. For lets encrypt solution, TLS should be terminated on the edge of the OpenShift route or kubermetes ingres. Podium will automatically deploy OpenShift routes with edge termination and dynamically configure certificates using lets encrypt. You can of course configure your own routes or ingres.

[Setup Lets Encrypt on OpenShift](https://keithtenzer.com/2020/04/03/openshift-application-certificate-management-with-lets-encrypt/)

## Deployment
You can deploy Podium using [Podium Operator](podium-operator/README.md) for OpenShift 4 or [Deployment Templates](docs/TEMPLATE_DEPLOYMENT.md) for OpenShift 3/4.
