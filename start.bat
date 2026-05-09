@echo off
setlocal enabledelayedexpansion

set "ROOT_DIR=%~dp0"
if "%ROOT_DIR:~-1%"=="\" set "ROOT_DIR=%ROOT_DIR:~0,-1%"

echo [1/8] Switching to repo root...
cd /d "%ROOT_DIR%" || goto :fail

echo [2/8] Removing old Kubernetes resources if present...
kubectl delete -f "%ROOT_DIR%\k8s\ingress" --ignore-not-found
kubectl delete -f "%ROOT_DIR%\k8s\ecommerce" --ignore-not-found
kubectl delete -f "%ROOT_DIR%\k8s\images" --ignore-not-found
kubectl delete -f "%ROOT_DIR%\k8s\product" --ignore-not-found

echo [3/8] Removing stale local Docker images...
docker rmi ecommerce:v2 images:v2 product-service:v2 2>nul

echo [4/8] Building product-service...
cd /d "%ROOT_DIR%\microservices\product" || goto :fail
call mvn clean package
if errorlevel 1 goto :fail
docker build --no-cache -t product-service:v2 .
if errorlevel 1 goto :fail

echo [5/8] Building images...
cd /d "%ROOT_DIR%\microservices\images" || goto :fail
call mvn clean package
if errorlevel 1 goto :fail
docker build --no-cache -t images:v2 .
if errorlevel 1 goto :fail

echo [6/8] Building ecommerce...
cd /d "%ROOT_DIR%\microservices\ecommerce" || goto :fail
call mvn clean package
if errorlevel 1 goto :fail
docker build --no-cache -t ecommerce:v2 .
if errorlevel 1 goto :fail

echo [7/8] Deploying Kubernetes resources...
cd /d "%ROOT_DIR%" || goto :fail
kubectl apply -f "%ROOT_DIR%\k8s\namespace.yaml"
if errorlevel 1 goto :fail
kubectl apply -f "%ROOT_DIR%\k8s\product"
if errorlevel 1 goto :fail
kubectl apply -f "%ROOT_DIR%\k8s\images"
if errorlevel 1 goto :fail
kubectl apply -f "%ROOT_DIR%\k8s\ecommerce"
if errorlevel 1 goto :fail
kubectl apply -f "%ROOT_DIR%\k8s\ingress"
if errorlevel 1 goto :fail

echo [8/8] Waiting for deployments and showing status...
kubectl rollout status deployment/product -n ecommerce
if errorlevel 1 goto :fail
kubectl rollout status deployment/images -n ecommerce
if errorlevel 1 goto :fail
kubectl rollout status deployment/ecommerce -n ecommerce
if errorlevel 1 goto :fail

echo.
echo Pods:
kubectl get pods -n ecommerce
echo.
echo Services:
kubectl get svc -n ecommerce
echo.
echo Ingress:
kubectl get ingress -n ecommerce
echo.
echo Startup complete.
echo Test with:
echo   kubectl logs -n ecommerce deploy/product
echo   kubectl logs -n ecommerce deploy/images
echo   kubectl logs -n ecommerce deploy/ecommerce
echo   curl http://localhost/ecommerceApp/ecommerce-service/ecommerceProducts
goto :eof

:fail
echo.
echo Startup failed. Check the command output above.
exit /b 1
