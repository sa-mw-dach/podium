#!/bin/bash
LAST_VERSION="1.0.2"
VERSION="1.0.3"

cd ../podium-operator
echo "Building Operator..."
sudo operator-sdk build quay.io/ktenzer/podium-operator:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Pushing operator to repository..."
sudo docker push quay.io/ktenzer/podium-operator:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Building OLM catalog bundle..."
sudo operator-sdk bundle create quay.io/ktenzer/podium-operator-catalog:$VERSION --channels alpha --package podium-operator-catalog --directory deploy/olm-catalog/podium-operator/$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Pushing bundle to repository..."
sudo docker push quay.io/ktenzer/podium-operator-catalog:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Building OPM Catalog Index..."
#sudo opm index add -c docker --bundles quay.io/ktenzer/podium-operator-catalog:$VERSION --tag quay.io/ktenzer/podium-operator-index:$VERSION
sudo opm index add -c docker --bundles quay.io/ktenzer/podium-operator-catalog:$LAST_VERSION --bundles quay.io/ktenzer/podium-operator-catalog:$VERSION --tag quay.io/ktenzer/podium-operator-index:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Pushing Catalog Index to registry..."
sudo docker push quay.io/ktenzer/podium-operator-index:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "OLM Operator build completed successfully"
