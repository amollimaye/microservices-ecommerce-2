cd C:\git\microservices-ecommerce-2

cd microservices\product
mvn clean package
docker build -t product-service:latest .

cd ..\images
mvn clean package
docker build -t images:latest .

cd ..\ecommerce
mvn clean package
docker build -t ecommerce:latest .

cd ..\..
kubectl delete -f k8s\ingress\ --ignore-not-found
kubectl delete -f k8s\ecommerce\ --ignore-not-found
kubectl delete -f k8s\images\ --ignore-not-found
kubectl delete -f k8s\product\ --ignore-not-found

kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\product\
kubectl apply -f k8s\images\
kubectl apply -f k8s\ecommerce\
kubectl apply -f k8s\ingress\

kubectl rollout status deployment/product -n ecommerce
kubectl rollout status deployment/images -n ecommerce
kubectl rollout status deployment/ecommerce -n ecommerce

kubectl get pods -n ecommerce
kubectl get svc -n ecommerce
kubectl get ingress -n ecommerce
