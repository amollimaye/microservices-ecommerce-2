# microservices-ecommerce-2

Phase 1 modernization of the sample ecommerce microservices project to a Kubernetes-native local runtime.

## Prerequisites

Install and verify these before running the project:

* Java 17
* Maven 3.8+
* Docker Desktop
* Kubernetes enabled in Docker Desktop
* `kubectl` available in your terminal

Quick checks:

```powershell
java -version
mvn -version
docker version
kubectl version --client
kubectl get nodes
```

Expected:

* Docker Desktop is running
* Kubernetes is enabled
* `kubectl get nodes` shows the local Docker Desktop node as `Ready`

## Local Setup

1. Clone or download the repository.
2. Open a terminal in the project root:

```powershell
cd C:\git\microservices-ecommerce-2
```

3. Confirm the Kubernetes manifests are present under `k8s\`.
4. Confirm the helper script exists:

```powershell
dir start.bat
```

## How To Run Locally

Use the provided startup script from the repository root:

```powershell
start.bat
```

What `start.bat` does:

* removes old Kubernetes resources for this app
* removes stale local Docker images for this app
* builds all three Spring Boot services
* builds Docker images with explicit `v2` tags
* deploys the Kubernetes manifests
* waits for the three deployments to become ready
* prints pod, service, and ingress status

## Services

The application runs as three services inside Kubernetes:

* `ecommerce`
* `product`
* `images`

Internal service discovery uses Kubernetes DNS:

* `http://ecommerce-service:8090`
* `http://product-service:8090`
* `http://images-service:8090`

## Local Access

For Docker Desktop local access, use:

```text
http://localhost:8090/ecommerce-service/ecommerceProducts
```

This works because `ecommerce-service` is exposed as a Kubernetes `LoadBalancer` service on port `8090`.

## Verification

Check that everything is running:

```powershell
kubectl get pods -n ecommerce
kubectl get svc -n ecommerce
kubectl get ingress -n ecommerce
```

Expected:

* `product`, `images`, and `ecommerce` pods are `1/1 Running`
* `ecommerce-service` is exposed on port `8090`

Test the main API:

```powershell
curl http://localhost:8090/ecommerce-service/ecommerceProducts
```

Useful log commands:

```powershell
kubectl logs -n ecommerce deploy/product
kubectl logs -n ecommerce deploy/images
kubectl logs -n ecommerce deploy/ecommerce
```

## Notes

This project no longer uses:

* `nginx`
* `consul`
* `consul-template`
* `HOST_IP`
* `docker-compose` runtime routing

The `Ingress` manifest is still present as part of the Phase 1 Kubernetes migration, but on a default Docker Desktop setup the stable local endpoint for this repo is the `LoadBalancer` service URL on `localhost:8090`.
