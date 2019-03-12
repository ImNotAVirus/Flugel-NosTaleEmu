# Flugel

[![Build Status](https://travis-ci.com/ImNotAVirus/Flugel-NostaleEmu.svg?branch=master)](https://travis-ci.com/ImNotAVirus/Flugel-NostaleEmu)

## What is Flugel

This project is only a test for the toolkit [ElvenGard](https://github.com/ImNotAVirus/ElvenGard_V2).

## Deploy and test the project

### Docker build

    cd .deploy
    cp ~/.ssh/id_rsa.pub .
    docker build -t elixir-deploy .
    docker run --rm -p22:22 [... some options ...] elixir-deploy

### Docker get IP address

    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name
    # Or for all containers
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' `docker ps -q`

### Deploy application

    cp .deliver/config.example .deliver/config
    nano .deliver/config
    ssh-keygen -R ip_addy
    mix edeliver build release production

## Contributing

Currently developing this project, I will often open pull-requests. Any review is welcome.
