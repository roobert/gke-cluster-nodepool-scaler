# GKE Cluster Nodepool Scaler

A GCP Function to scale GKE cluster nodepools up or down.

## Local Testing
```
PROJECT_ID=project0
ZONE=europe-west1-b
CLUSTER=cluster0
NODEPOOL=nodepool0

# scale down
NODES=0 ./src/main.py

# scale up
NODES=1 ./src/main.py
```

## Deployment

See [gke-cluster-nodepool-scaler.tf](gke-cluster-nodepool-scaler.tf).
