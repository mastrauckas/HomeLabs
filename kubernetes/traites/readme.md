# Introduction

This will show how traits work. Traits prevent pods from
being deployed on a node unless that node has a toleration
for that trait.

This test will setup a Kubernetes cluster will 3 nodes all using Kubernetes v1.29.

## Test 1

1. Run `kind create cluster --config .\kind-cluster.yaml`.
2. View your cluster with `kind get clusters`.
3. Put a trait on node 1 with `kubectl taint nodes trait-cluster-test-worker dotnet=6.0:NoSchedule`.
4. Now add a pod with no tolerations with `kubectl apply -f .\pods-example1.yaml`.
5. Delete cluster by running `delete clusters trait-cluster-test`
