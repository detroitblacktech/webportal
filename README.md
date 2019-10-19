## Overview
This project is a docker project which means it runs a self-contained instance on your local computer. Configuration should be minimal and you should be running the project in under 5 minutes.

## Running inside the docker image

- CentOS >= 5.x
- Python 3.4 or higher
- MySQL 5.x 

## Configure Database Settings

Change the MySQL Database settings in settings.py to reflect your development mysql instance

## Pre-requisites
- Docker: https://docs.docker.com/
- MySQL: MAMP (https://www.mamp.info/en/) is suggested for quick setup on non-linux computers

## Setup
This assumes you have docker properly installed on your computer and mysql is configured.

```
docker build -t detroitpbx .
```
* 'detroitpbx' is an arbitrary name and can be anything as long as you remember it.

View a list of docker images with:
```
docker image ls
```
* You should see the name you used in the previous step

Run the project with:
```
docker run -p 4444:8080 detroitpbx
```
* You can use any available port number, but '4444' is used as an example. 8080 is the default port and is not arbitrary. 'detroitpbx' should be the same name see in your list of images.

## Tips
If you add new static assets to the project such as images, be sure to rerun the docker build command above.