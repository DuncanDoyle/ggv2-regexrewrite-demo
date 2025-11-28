# Gloo Gateway V2 - RegexRewrite Demo

## Installation

Set your Gloo Gateway v2 License Key:
```
export GLOO_GATEWAY_LICENSE_KEY={your-gloo-gateway-license-key}
```

Install Gloo Gateway v2:
```
cd install
./install-ggv2-with-helm.sh
```

> NOTE
> The Gloo Gateway version that will be installed is set in a variable at the top of the `install/install-ggv2-with-helm.sh` installation script.

## Setup the environment

Run the `install/setup.sh` script to setup the environment:

- Create the required namespaces
- Deploy the Gateway
- Deploy the ExtAuth GatewayExtension
- Deploy the HTTPBin application
- Deploy the Reference Grants
- Deploy the HTTPRoute (K8S Gateway API)
- Deploy the AuthConfig and GlooTrafficPolicy

```
./setup.sh
```

## Access the HTTPBin application

This demo shows how you can use a Transformation configured in a `GlooTrafficPolicy` to implement a regular expression path rewrite. This is done in the `/policies/regexrewrite-transformation-glootrafficpolicy.yaml` configuration file. The Transformation uses regular expressions to rewrite the `:path` header of the request, which changes the path of the request to the upstream workload (service).

In this demo, the regular expression `^\/v1\/\d{3}\/status$` will match the `/v1/{status-code}/status` request, which will be rewritten to `/status/{status-code}`


We can test this regex-rewrite with the following request:

```
curl -v -H "Authorization: basic $(printf 'user:password' | base64)" http://api.example.com/v1/202/status
```

The path of this request will be rewritten to `/status/202`. 


```
./curl-request.sh
```

or

```
curl -v -H "Authorization: basic $(echo -n 'user:password' | base64)" http://api.example.com/v1/202/status
```