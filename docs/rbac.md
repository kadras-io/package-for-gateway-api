# Access to the Resources

The package extends the Kubernetes [default roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles) with the Gateway API resources, via [aggregation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#aggregated-clusterroles). The users bound to `admin`, `edit`, or `view` in a namespace get the following permissions on the resources in that namespace.

| Resources | `admin`, `edit` | `view` |
|-----------|-----------------|--------|
| HTTPRoute, GRPCRoute, TCPRoute, TLSRoute, UDPRoute | Read and write | Read |
| ReferenceGrant, BackendTLSPolicy | Read and write | Read |
| Gateway, ListenerSet | Read | Read |
| XBackend, XBackendTrafficPolicy (experimental) | Read | Read |

The Gateways are read-only, since they're managed by the platform: creating one provisions dedicated proxies and load balancers. The routes of any namespace can attach to the shared Gateways that allow them, like the ones of the [Envoy Gateway](https://github.com/kadras-io/package-for-envoy-gateway) package.

The permissions are granted by the `gateway-api-edit` and `gateway-api-view` ClusterRoles. To grant more, for example to let a team manage its own Gateways, bind an additional role.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: gateway-editor
rules:
  - apiGroups: ["gateway.networking.k8s.io"]
    resources: ["gateways"]
    verbs: ["create", "delete", "patch", "update"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: gateway-editor
  namespace: team-a
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: gateway-editor
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: Group
    name: team-a-admins
```
