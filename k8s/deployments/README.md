# Introduction

This will go into how jobs deployments work in kubernetes.

## Lab 1 - `RollingUpdate` with`maxUnavailable` and `maxSurge` at 100%
  
- This will cause the current `ReplicaSet` to tear down and the new `ReplicaSet` to get created at the same time.