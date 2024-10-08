# aks-entra-id-users

The purpose of this repository is to show how to manage RBAC in Azure Kubernetes Service (AKS) using Entra ID users.

## Prerequisites
- Azure Subscription
- Azure CLI
- Terraform
- kubectl
- kubelogin
- Taskfile

## Overview

Start by creating the test stack:

1. Navigate to the [terraform](./terraform/) directory.

2. Modify the [locals](./terraform/locals.tf) file by updating the value of `authorized_ip` (you can optionally modify the tags too).

3. Run the following commands:

    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

    This should create 4 resources in total.

Next, follow these steps:

1. Access your new Kubernetes cluster with `task kubeadminaccess`. This will retrieve the admin kubeconfig from Azure and also ensure that `kubectl` and `kubelogin` are properly configured.

2. Open and modify one of the manifest files in the [manifests](./manifests/) directory(using frontend.yaml for this example) to include the Entra ID user or Group Object ID you want to add and configure:

    ```yaml
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: frontend-developer-role-binding
      namespace: frontend-app-1
    subjects:
    - kind: User # or Group
      name: # user upn or group object id
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: edit
      apiGroup: rbac.authorization.k8s.io
    ```

    Apply it with either `kubectl apply -f manifests/frontend.yaml` or `task fe`. This will create a Namespace, RoleBinding, and a testing Pod.

3. After adding your user account (or the group you're assigned to) to the `frontend-developer-role-binding` RoleBinding, retrieve the user access token with `task kubeuseraccess`. You should now be able to:

    - Access the frontend-app-1 namespace:

        ```bash
        kubectl get pods -n frontend-app-1
        ```

    - Access the frontend-app-1 pod:

        ```bash
        kubectl logs <pod-name> -n frontend-app-1
        ```

    - Enter a pod's shell:

        ```bash
        kubectl exec -it <pod-name> -n frontend-app-1 -- /bin/bash
        ```
