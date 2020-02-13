# Flugel

[![Build Status](https://travis-ci.com/ImNotAVirus/Flugel-NostaleEmu.svg?branch=master)](https://travis-ci.com/ImNotAVirus/Flugel-NostaleEmu)

## What is Flugel

This project is only a test for the toolkit [ElvenGard](https://github.com/ImNotAVirus/ElvenGard_V2).

## Deploy and test the project

### Build Docker image

    cd .deploy
    cp ~/.ssh/id_rsa.pub .
    docker build -t elixir-deploy .
    docker run --rm -p22:22 [... some options ...] elixir-deploy

### Get container addresses

    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name
    # Or for all containers running
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' `docker ps -q`

### Deploy a single application

    cp .deliver/config.example .deliver/config
    nano .deliver/config
    ssh-keygen -R ip_addy
    mix edeliver build release production
    mix edeliver deploy release to production
    mix edeliver start production

### Deploy a cluster

You can also deploy a cluster using docker-compose.

    cp .deploy/docker-compose.yml.example .deploy/docker-compose.yml
    nano .deploy/docker-compose.yml
    docker-compose up --build

### Deploy on Kubernetes (with Minikube)

    # Build all images
    docker build --build-arg APP_NAME=login_service -t login_service -f .k8s/Dockerfile .
    docker build --build-arg APP_NAME=channel_service -t channel_service -f .k8s/Dockerfile .
    docker build --build-arg APP_NAME=session_manager -t session_manager -f .k8s/Dockerfile .
    docker build --build-arg APP_NAME=world_manager -t world_manager -f .k8s/Dockerfile .

    # Add them to minikube's cache
    minikube cache add login_service channel_service session_manager world_manager

    # Deploy staging
    kustomize build .k8s/staging | kubectl apply -f -

    # Deploy production
    kustomize build .k8s/production | kubectl apply -f -

    # Deploy both
    kustomize build .k8s | kubectl apply -f -

## Contributing

Currently developing this project, I will often open pull-requests. Any review is welcome.
