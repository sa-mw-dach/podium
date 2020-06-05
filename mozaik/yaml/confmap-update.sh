#!/bin/bash
OPTIND=1

# This script replaces a ConfigMap object in OpenShift by a new object provided in a yaml template.
# The options (n)amespace and application_(d)omain pass the according parameters to that template.
# An additional option (c)onfigmap can be useful when appying this script for other use cases than the
# mozaik-config ConfigMap in Podium.

# This first section reads the defined command line arguments.
# One last positional argument may be provided to pass the yaml template name
# Any other argument is ignored.
while getopts "c:n:d:" opt; do
	case $opt in
		y) yaml_file=$OPTARG
			;;
		c) configmap=$OPTARG
			;;
		n) namespace=$OPTARG
			;;
		d) application_domain=$OPTARG
			;;
	esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

# Setting the default values
yaml_file=${yaml_file:-$@}
configmap=${configmap:-mozaik-config}
namespace=${namespace:-podium}
application_domain=${application_domain:-apps.cloud.example.com}

# First we delete the existing ConfigMap
oc delete configmap/$configmap

# We immediately create the new ConfigMap object. If the Podium has been deployed by the Podium Operator,
# the absence of this ConfigMap object may trigger a re-creation of the original object by the Operator.
# We expect the creation here to be so fast that the Operator does not take notice.

# In case you have trouble with the Operator, you may want to set the Operator objects spec.mozaik.enable to false.
# oc patch Podium mypodium -p '{"spec":{"mozaik":{"enable": false }}}' --type merge -n $namespace

oc process -f $yaml_file -p NAMESPACE=$namespace -p APPLICATION_DOMAIN=$application_domain | oc create -f -

# Unfortunately, there is no trigger avalable that automatically restarts the Mozaik Pod after the
# ConfigMap Object has changed. In order to activate the new ConfigMap, we trigger a re-deployment
# instead. To achieve this, we add the sha256sum of our new ConfigMap as annotation to the Mozaik
# deployment. Whenever this annotation changes, the re-deployment is triggered automatically.
configHash=$(oc get cm/mozaik-config -oyaml | sha256sum | cut -d' ' -f1)
patch="{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"configHash\":\"$configHash\"}}}}}"
oc patch deployment mozaik -p $patch -n $namespace
