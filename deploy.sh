#!/bin/bash

case "$1" in
	"native" | "")
	python3.5 app.py
	;;
	"docker")
	docker build -t dsiprouter .
	docker rm -f dsiprouter-app
	docker run -p 80:80 -dit --restart always --name dsiprouter-app dsiprouter
	;;	
esac
