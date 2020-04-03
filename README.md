# GKE Cluster Nodepool Scaler

Functions which can be triggered to scale a cluster nodepool up or down.

## Example
```
# manual testing
PROJECT_ID=project0 ZONE=europe-west1-b CLUSTER=cluster0 NODEPOOL=nodepool0 NODES=0 ./src/main.py
PROJECT_ID=project0 ZONE=europe-west1-b CLUSTER=cluster0 NODEPOOL=nodepool0 NODES=1 ./src/main.py

# NODES can be read from event json when triggered from GCP function
PROJECT_ID=project0 ZONE=europe-west1-b CLUSTER=cluster0 NODEPOOL=nodepool0 main.py
PROJECT_ID=project0 ZONE=europe-west1-b CLUSTER=cluster0 NODEPOOL=nodepool0 main.py
```

## Deployment

See [gke-cluster-nodepool-scaler.tf](gke-cluster-nodepool-scaler.tf).
