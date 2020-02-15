#!/bin/bash
# Check if in development mode

if [ "$2" == "dev" ]; then
	volumemount="-v $(pwd):/usr/src/dbt"
fi

# We support navtively running it on the local machine or via docker
# We recommend docker

case "$1" in
	"native" | "")
	python3 app.py
	;;
	"docker")
	docker build -t dbtwebportal .

	if [ "$2" != "dev" ]; then
		sleep 30
	fi

	docker rm -f dbtwebportal-app
	docker run -p 80:80 -dit --restart always $volumemount --name dbtwebportal-app  -e SLACK_API_TOKEN=$SLACK_API_TOKEN dbtwebportal
	;;
esac
