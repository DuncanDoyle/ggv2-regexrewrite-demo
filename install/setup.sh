#!/bin/sh

pushd ..

# Deploy the Gateways

# Gateway
kubectl create namespace ingress-gw --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f gateways/gw-parameters.yaml
kubectl apply -f gateways/gw.yaml

# Create namespaces if they do not yet exist
# kubectl create namespace ingress-gw --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace httpbin --dry-run=client -o yaml | kubectl apply -f -

# Label the default namespace, so the gateway will accept the HTTPRoute from that namespace.
printf "\nLabel default namespace ...\n"
kubectl label namespaces default --overwrite shared-gateway-access="true"

# Deploy the HTTPBin application
printf "\nDeploy HTTPBin application ...\n"
kubectl apply -f apis/httpbin.yaml

# Reference Grants
printf "\nDeploy Reference Grants ...\n"
kubectl apply -f referencegrants/httpbin-ns/default-ns-httproute-service-rg.yaml

# HTTPRoute
printf "\nDeploy HTTPRoute ...\n"
kubectl apply -f routes/api-example-com-httproute.yaml

# AuthConfig
kubectl apply -f policies/authconfig/basic-authconfig.yaml

# GlooTrafficPolicies
kubectl apply -f policies/extauth-httproute-policy.yaml
kubectl apply -f policies/regexrewrite-transformation-glootrafficpolicy.yaml

popd