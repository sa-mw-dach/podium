#!/bin/bash
VERSION="1.0.4"

cd ../podium-operator
echo "Building Operator..."
sudo operator-sdk build quay.io/podium/podium-operator:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Pushing operator to repository..."
sudo docker push quay.io/podium/podium-operator:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Building OLM catalog bundle..."
sudo operator-sdk bundle create quay.io/podium/podium-operator-catalog:$VERSION --channels alpha --package podium-operator-catalog --directory deploy/olm-catalog/podium-operator/$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Pushing bundle to repository..."
sudo docker push quay.io/podium/podium-operator-catalog:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Building OPM Catalog Index..."
sudo opm index add -c docker --bundles quay.io/podium/podium-operator-catalog:1.0.2 --bundles quay.io/podium/podium-operator-catalog:1.0.3 --bundles quay.io/podium/podium-operator-catalog:$VERSION --tag quay.io/podium/podium-operator-index:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "Pushing Catalog Index to registry..."
sudo docker push quay.io/podium/podium-operator-index:$VERSION
if [ $? != 0 ]; then exit 1; fi

echo "OLM Operator build completed successfully"
