#!/bin/bash

cd ../podium-operator
echo "Building Operator..."
sudo operator-sdk build quay.io/ktenzer/podium-operator:latest
if [ $? != 0 ]; then exit 1; fi

echo "Pushing operator to repository..."
sudo docker push quay.io/ktenzer/podium-operator:latest
if [ $? != 0 ]; then exit 1; fi

echo "Building OLM catalog bundle..."
sudo operator-sdk bundle create quay.io/ktenzer/podium-operator-catalog:latest --channels alpha --package podium-operator-catalog --directory deploy/olm-catalog/podium-operator/1.0.0
if [ $? != 0 ]; then exit 1; fi

echo "Pushing bundle to repository..."
sudo docker push quay.io/ktenzer/podium-operator-catalog:latest
if [ $? != 0 ]; then exit 1; fi

echo "Building OPM Catalog Index..."
sudo opm index add -c docker --bundles quay.io/ktenzer/podium-operator-catalog:latest --tag quay.io/ktenzer/podium-operator-index:latest
if [ $? != 0 ]; then exit 1; fi

echo "Pushing Catalog Index to registry..."
sudo docker push quay.io/ktenzer/podium-operator-index:latest
if [ $? != 0 ]; then exit 1; fi

echo "OLM Operator build completed successfully"
