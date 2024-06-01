# Introduction

This will go into how jobs work on kubernetes.

## Lab 1 - Creating a one time job

This will create a job that runs right away, 1 time.

### How to Run

1. Run `kubectl apply -f .\yamls\lab-1-create-job.yaml`.
2. If you print the logs of the `pod`, you will see `I am a Kubernetes job!`.
3. You can view job information by running `kubectl get jobs -o wide`.
4. Delete the job by running `kubectl delete -f .\yamls\lab-1-create-job.yaml`.

## Lab 2 - Have multiple podFailurePolicy

This will create a job that can have multiple return codes that are random.

- Exit Code `0`: If it return exit code 0, it will complete for completing successfully.
- Exit Code `1`: This will incremented the backoffLimit. If you have a exit code of `1` 3 times, it will fail the job.
- Exit Code `2`: This will fail the job completely and not worry about the backoffLimit.

### How to Run

1. Run `kubectl apply -f .\yamls\lab-2-create-job.yaml`.
2. View the pods fail/successful state by running `kubectl get jobs -o wide`.
3. View the job by running ` k describe job print-message-job-example-2`.
4. Delete the job by running `kubectl delete -f .\yamls\lab-1-create-job.yaml`.
