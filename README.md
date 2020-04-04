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

## Overriding the Schedule

It's possible to override the schedule by triggering a scale up or scale down event through the GCP scheduler UI.

Alternatively use the provided helper script [`scale_nodepools.sh`](https://github.com/roobert/gke-cluster-nodepool-scaler/blob/master/scale_nodepools.sh), e.g:
```
# scale up all clusters across multiple GCP projects:
scale_nodepools.sh 0 "project0 project1 project2"
```


