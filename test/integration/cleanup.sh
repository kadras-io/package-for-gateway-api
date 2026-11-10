#!/usr/bin/env bash
#
# Removes what uninstalling the package leaves behind on purpose: the Gateway API CustomResourceDefinitions,
# and with them all the Gateway API resources. It also removes the `safe-upgrades` admission policy, in case
# it was installed by another app.
#
#   ../cleanup.sh

set -eo pipefail

kubectl get crds -o name | grep -E '\.gateway\.networking\.(x-)?k8s\.io$' | xargs -r kubectl delete --wait
kubectl delete validatingadmissionpolicybinding,validatingadmissionpolicy safe-upgrades.gateway.networking.k8s.io --ignore-not-found --wait
