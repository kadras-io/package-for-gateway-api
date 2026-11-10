# Upgrading and Uninstalling

## Upgrading

The package version matches the Gateway API version. Upgrade it before the packages relying on the Gateway API, like Envoy Gateway, when they require a newer version.

```shell
kctrl package installed update -i gateway-api \
  -p gateway-api.packages.kadras.io \
  -v ${VERSION} \
  -n kadras-system
```

The `safe-upgrades` admission policy rejects CustomResourceDefinitions older than v1.5.0, and standard CustomResourceDefinitions replaced by experimental ones. See the Gateway API [versioning policy](https://gateway-api.sigs.k8s.io/concepts/versioning/).

## Moving from CustomResourceDefinitions installed by another package

Previous versions of the Envoy Gateway package installed the Gateway API CustomResourceDefinitions themselves. When this package is installed, it takes over the existing CustomResourceDefinitions and the `safe-upgrades` admission policy, via the kapp `--dangerous-override-ownership-of-existing-resources` option. From then on, the other package doesn't own them anymore, and won't delete them when it stops including them.

Install this package first, then upgrade the Envoy Gateway package to a version relying on it. In the opposite order, the Envoy Gateway upgrade would delete the CustomResourceDefinitions it doesn't include anymore, and with them all the Gateways and routes in the cluster.

## Uninstalling

Uninstalling the package deletes the `safe-upgrades` admission policy, and keeps the CustomResourceDefinitions, so that the Gateways and routes in the cluster aren't deleted with them. When installed again, the package adopts them.

```shell
kctrl package installed delete -i gateway-api -n kadras-system
```

To remove the CustomResourceDefinitions too, after uninstalling all the Gateway API implementations, delete them explicitly. It deletes all the Gateway API resources in the cluster.

```shell
kubectl get crds -o name | grep -E '\.gateway\.networking\.(x-)?k8s\.io$' | xargs kubectl delete
```
