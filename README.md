# microservices-ecommerce-2

Phase 1 modernization for Kubernetes-native runtime.

## Architecture

Browser -> Kubernetes Ingress -> Kubernetes Services -> Pods

Services:

* ecommerce
* product
* images

## Runtime

This project no longer requires the legacy runtime stack:

* nginx
* legacy service registry
* template-based reverse proxy configuration
* HOST_IP routing
* docker-compose service discovery

Service discovery now uses Kubernetes DNS:

* `http://ecommerce-service:8090`
* `http://product-service:8090`
* `http://images-service:8090`

## Build Images

```bash
cd microservices/product && mvn clean package && docker build -t product-service:latest .
cd ../images && mvn clean package && docker build -t images:latest .
cd ../ecommerce && mvn clean package && docker build -t ecommerce:latest .
```

## Deploy To Kubernetes

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/product/
kubectl apply -f k8s/images/
kubectl apply -f k8s/ecommerce/
kubectl apply -f k8s/ingress/
```

## Routes

* `/ecommerceApp` -> `ecommerce-service`
* `/product` -> `product-service`
* `/images` -> `images-service`

The ingress rewrites the external prefixes to the existing Spring application paths so the REST APIs remain unchanged.

## Verify

```bash
kubectl get pods -n ecommerce
kubectl get svc -n ecommerce
kubectl get ingress -n ecommerce
kubectl describe ingress ecommerce-ingress -n ecommerce
kubectl port-forward -n ecommerce svc/ecommerce-service 8090:8090
curl http://localhost:8090/ecommerce-service/ecommerceProducts
curl http://<INGRESS-HOST>/ecommerceApp/ecommerce-service/ecommerceProducts
```
