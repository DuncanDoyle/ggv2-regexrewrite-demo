
#!/bin/sh

# export KGATEWAY_VERSION="v2.0.0"
# export GGV2_VERSION="2.0.0-rc.2"
export GGV2_VERSION="2.0.1"
export GGV2_HELM_VALUES_FILE="ggv2-helm-values.yaml"
export K8S_GW_API_VERSION="v1.4.0"
export GGV2_SYSTEM_NAMESPACE="gloo-gateway-system"

if [ -z "$GLOO_GATEWAY_LICENSE_KEY" ]
then
   echo "Gloo Gateway License Key not specified. Please configure the environment variable 'GLOO_GATEWAY_LICENSE_KEY' with your Gloo Gateway License Key."
   exit 1
fi


#----------------------------------------- Preload the Gloo Gateway images, as they require an ImagePullPolicy to fetch from an private repo -----------------------------------------

printf "\nApply K8S Gateway CRDs ....\n"
# kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/$K8S_GW_API_VERSION/standard-install.yaml
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/$K8S_GW_API_VERSION/experimental-install.yaml


printf "\nInstall Gloo Gateway v2 CRDs ....\n"
helm upgrade --install gloo-gateway-crds oci://us-docker.pkg.dev/solo-public/gloo-gateway/charts/gloo-gateway-crds \
    --version $GGV2_VERSION \
    --namespace $GGV2_SYSTEM_NAMESPACE \
    --create-namespace \
    --set installExtAuthCRDs=true \
    --set installRateLimitCRDs=true

printf "\nInstall Gloo Gateway v2 ...\n"
helm upgrade --install gloo-gateway oci://us-docker.pkg.dev/solo-public/gloo-gateway/charts/gloo-gateway \
    --version $GGV2_VERSION \
    --namespace $GGV2_SYSTEM_NAMESPACE \
    --create-namespace \
    --set-string licensing.glooGatewayLicenseKey=$GLOO_GATEWAY_LICENSE_KEY \
    --set-string licensing.agentgatewayLicenseKey=$GLOO_GATEWAY_LICENSE_KEY \
    -f $GGV2_HELM_VALUES_FILE