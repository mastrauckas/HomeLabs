# Items to Research

- Horizontal Pod Autoscaling (HPA)
- Prometheus
- Security
  - SecurityContext
  - Service Accounts
- User Namespaces
  - not running as root user.
- Hooks
  - PostStart
  - PreStop
- Init Containers
- Sidecar Containers
- Storage
- RBAC
- Downward API
- QoS Class/Resource Quotas
  - request
  - limit
  - priority
- Scheduling, Preemption and Eviction
  - affinity
  - anti affinity
  - Node affinity weight
  - podAntiAffinity
  - podAffinity
  - topologySpreadConstraints
- Add-Ons, Extensions
- Probes
  - Liveness
  - Readiness
  - Startup Probes
- Configuration
  - ConfigMaps
  - Secrets
- Jobs
  - ~~Normal single Job.~~
  - Normal multiple Jobs.
  - Considered failed by exit code.
  - backoffLimit
  - activeDeadlineSeconds
  - startingDeadlineSeconds  
  - restartPolicy
    - Never
    - run OnFailure
  - podFailurePolicy
    - FailJob
    - Ignore
    - Count
    - FailIndex
    - Restrict by container name
  - Recurring cron job
    - Run a recurring.
    - When a recurring jobs
    - Will recurring overlap
  - parallelism
  - completions
  - completionMode
  - successPolicy
- PodDisruptionBudget
  - Disruptions
- Draining
- Labels
  - nodeselector
- Taints and Tolerations
- [Scheduling, Preemption and Eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/)