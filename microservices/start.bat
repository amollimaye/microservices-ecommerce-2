@echo off
setlocal enabledelayedexpansion

REM Set colors for output
set "GREEN=[92m"
set "RESET=[0m"

echo.
echo ============================================
echo Setting HOST_IP for Windows
echo ============================================
set HOST_IP=host.docker.internal
echo HOST_IP set to: %HOST_IP%

echo.
echo ============================================
echo Building PRODUCT service
echo ============================================
cd product
call mvn clean package -DskipTests

if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] PRODUCT build failed
    pause
    exit /b !ERRORLEVEL!
)

cd ..

echo.
echo ============================================
echo Building ECOMMERCE service
echo ============================================
cd ecommerce
call mvn clean package -DskipTests

if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] ECOMMERCE build failed
    pause
    exit /b !ERRORLEVEL!
)

cd ..

echo.
echo ============================================
echo Building IMAGES service
echo ============================================
cd images
call mvn clean package -DskipTests

if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] IMAGES build failed
    pause
    exit /b !ERRORLEVEL!
)

cd ..

echo.
echo ============================================
echo Building Docker Images
echo ============================================

docker build -t product:latest ./product

if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] PRODUCT Docker build failed
    pause
    exit /b !ERRORLEVEL!
)

echo PRODUCT Docker image built successfully

docker build -t ecommerce:latest ./ecommerce

if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] ECOMMERCE Docker build failed
    pause
    exit /b !ERRORLEVEL!
)

echo ECOMMERCE Docker image built successfully

docker build -t images:latest ./images

if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] IMAGES Docker build failed
    pause
    exit /b !ERRORLEVEL!
)

echo IMAGES Docker image built successfully

echo.
echo ============================================
echo Stopping any existing containers
echo ============================================
docker-compose down

echo.
echo ============================================
echo Starting Docker Compose
echo ============================================
docker-compose up -d

if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] Docker Compose startup failed
    pause
    exit /b !ERRORLEVEL!
)

echo.
echo ============================================
echo Waiting for services to be ready
echo ============================================
timeout /t 5 /nobreak

echo.
echo ============================================
echo ALL SERVICES STARTED SUCCESSFULLY
echo ============================================
echo.
docker ps

echo.
echo ============================================
echo Service Access URLs
echo ============================================
echo Consul UI:        http://localhost:8500
echo NGINX:            http://localhost:8080
echo ecommerceApp:     http://localhost:8080/ecommerceApp
echo productApp:       http://localhost:8080/productApp
echo imageApp:         http://localhost:8080/imageApp
echo.

pause
