#!/usr/bin/env python
#
# Scale a GKE Cluster NodePool
#
# REFERENCES
# * https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1/projects.zones.clusters.nodePools/setSize

import os
import json
from base64 import b64decode
from dataclasses import dataclass, field
from googleapiclient import discovery
from oauth2client.client import GoogleCredentials


def main(event, context):
    print(f"event: {event}")
    print(f"context: {context}")

    nodes = 0
    data = event.get("data")

    if data:
        payload = json.loads(b64decode(data))
        if payload.get("nodes"):
            nodes = payload["nodes"]

    gke_nodepool_scaler(nodes)


def gke_nodepool_scaler(nodes=0):
    if os.environ.get("NODES"):
        nodes = os.environ["NODES"]

    try:
        nodepool_scaler = GKEClusterNodepoolScaler(
            project_id=os.environ["PROJECT_ID"],
            zone=os.environ["ZONE"],
            cluster=os.environ["CLUSTER"],
            nodepool=os.environ["NODEPOOL"],
            nodes=nodes,
        )
        nodepool_scaler.scale()
    except KeyError as error:
        raise KeyError(f"environment variable not set: {error}")


@dataclass
class GKEClusterNodepoolScaler:
    project_id: str
    zone: str
    cluster: str
    nodepool: str
    nodes: int
    service: None = field(init=False)

    def __post_init__(self):
        credentials = GoogleCredentials.get_application_default()
        self.service = discovery.build(
            "container", "v1", credentials=credentials, cache_discovery=False
        )

    def scale(self):
        request_body = {
            "nodeCount": self.nodes,
            "name": f"projects/{self.project_id}"
            f"/locations/{self.zone}"
            f"/clusters/{self.cluster}"
            f"/nodePools/{self.nodepool}",
        }

        request = (
            self.service.projects()
            .zones()
            .clusters()
            .nodePools()
            .setSize(
                projectId=self.project_id,
                zone=self.zone,
                clusterId=self.cluster,
                nodePoolId=self.nodepool,
                body=request_body,
            )
        )
        response = request.execute()

        print(response)


if __name__ == "__main__":
    gke_nodepool_scaler()
