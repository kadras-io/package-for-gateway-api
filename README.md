# Gateway API

![Test Workflow](https://github.com/kadras-io/package-for-gateway-api/actions/workflows/test.yml/badge.svg)
![Release Workflow](https://github.com/kadras-io/package-for-gateway-api/actions/workflows/release.yml/badge.svg)
[![The SLSA Level 3 badge](https://slsa.dev/images/gh-badge-level3.svg)](https://slsa.dev/spec/v1.0/levels)
[![The Apache 2.0 license badge](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Follow us on Bluesky](https://img.shields.io/static/v1?label=Bluesky&message=Follow&color=1DA1F2)](https://bsky.app/profile/kadras.bsky.social)

A Carvel package for the [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io) CustomResourceDefinitions, the API to expose and route traffic to applications on Kubernetes. They're shared by the implementations in the cluster, like [Envoy Gateway](https://github.com/kadras-io/package-for-envoy-gateway), and by the tools working with them, like [cert-manager](https://github.com/kadras-io/package-for-cert-manager).

## ✨&nbsp; What's Included

* **Gateway API CustomResourceDefinitions**. The experimental channel, in the version required by the Envoy Gateway package: the standard resources, like Gateway and HTTPRoute, plus the experimental ones, like TCPRoute, UDPRoute, and XBackendTrafficPolicy.
* **Safe upgrades**. The upstream `safe-upgrades` admission policy, which prevents installing experimental CustomResourceDefinitions on top of standard ones, and versions older than v1.5.0.
* **Safe uninstall**. Uninstalling the package keeps the CustomResourceDefinitions, so that the Gateways and routes in the cluster, and the traffic they serve, aren't deleted with it.
* **Single ownership**. Existing CustomResourceDefinitions, installed for example by a previous version of the Envoy Gateway package, are adopted by this package.

## 🚀&nbsp; Getting Started

### Prerequisites

* Kubernetes 1.35+
* Carvel [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI.
* Carvel [kapp-controller](https://carvel.dev/kapp-controller) deployed in your Kubernetes cluster. You can install it with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

```shell
kapp deploy -a kapp-controller -y \
  -f https://github.com/carvel-dev/kapp-controller/releases/latest/download/release.yml
```

### Dependencies

The Gateway API CustomResourceDefinitions have no dependencies. Install this package before the packages relying on them, like [Envoy Gateway](https://github.com/kadras-io/package-for-envoy-gateway) and [cert-manager](https://github.com/kadras-io/package-for-cert-manager).

Some Kubernetes distributions and cloud providers install and manage the Gateway API CustomResourceDefinitions themselves. In that case, don't install this package: it would take them over, and conflict with their manager.

### Installation

Add the Kadras [package repository](https://github.com/kadras-io/kadras-packages) to your Kubernetes cluster:

```shell
kctrl package repository add -r kadras-packages \
  --url ghcr.io/kadras-io/kadras-packages \
  -n kadras-system --create-namespace
```

<details><summary>Installation without package repository</summary>
The recommended way of installing the Gateway API package is via the Kadras <a href="https://github.com/kadras-io/kadras-packages">package repository</a>. If you prefer not using the repository, you can add the package definition directly using <a href="https://carvel.dev/kapp/docs/latest/install"><code>kapp</code></a> or <code>kubectl</code>.

```shell
kubectl create namespace kadras-system
kapp deploy -a gateway-api-package -n kadras-system -y \
  -f https://github.com/kadras-io/package-for-gateway-api/releases/latest/download/metadata.yml \
  -f https://github.com/kadras-io/package-for-gateway-api/releases/latest/download/package.yml
```
</details>

Install the Gateway API package:

```shell
kctrl package install -i gateway-api \
  -p gateway-api.packages.kadras.io \
  -v ${VERSION} \
  -n kadras-system
```

> **Note**
> You can find the `${VERSION}` value by retrieving the list of package versions available in the Kadras package repository installed on your cluster.
> 
> ```shell
> kctrl package available list -p gateway-api.packages.kadras.io -n kadras-system
> ```

Verify the installed packages and their status:

```shell
kctrl package installed list -n kadras-system
```

### Try It Out

List the Gateway API resources available in the cluster:

```shell
kubectl api-resources --api-group=gateway.networking.k8s.io
kubectl api-resources --api-group=gateway.networking.x-k8s.io
```

## 📙&nbsp; Documentation

Documentation, tutorials and examples for this package are available in the [docs](docs) folder.
For documentation specific to the Gateway API, check out [gateway-api.sigs.k8s.io](https://gateway-api.sigs.k8s.io).

* [Upgrading and uninstalling](docs/upgrade.md)
* [Verifying the release](docs/verify-release.md)

## 🎯&nbsp; Configuration

The Gateway API package has no configurable values. The package version matches the Gateway API version, and its channel is always the experimental one, as required by Envoy Gateway. Any resource can still be customized via [ytt overlays](https://carvel.dev/ytt/docs/latest/ytt-overlays/), stored in a Secret and referenced from the PackageInstall via the `ext.packaging.carvel.dev/ytt-paths-from-secret-name.0` annotation.

## 🛠️&nbsp; Development

The development environment is defined with [devenv](https://devenv.sh). Enter it with `devenv shell`, or automatically with [direnv](https://direnv.net) after running `direnv allow`. Run `task --list` to see all the available tasks.

```shell
# Run the unit tests, which render the package and check the result without a cluster.
task test:config

# Create a local kind cluster and run the integration tests on it.
task cluster:setup
task test:integration

# Deploy the package from the local sources to the current cluster.
task dev
```

The unit tests are described in [test/unit/README.md](test/unit/README.md). To update the Gateway API version, change the tag in `package/vendir.yml`, run `vendir sync` in the `package` folder, and align it with the version required by the Envoy Gateway package.

## 🛡️&nbsp; Security

The security process for reporting vulnerabilities is described in [SECURITY.md](SECURITY.md).

## 🖊️&nbsp; License

This project is licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for more information.
