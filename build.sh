#!/bin/sh

_grafana_tag=$1
_grafana_version=$(echo ${_grafana_tag} | cut -d "v" -f 2)
_docker_repo=${2:-grafana/grafana}
_grafana_uid=${3:-472}
_grafana_gid=${4:-472}


echo ${_grafana_version}

if [ "$_grafana_version" != "" ]; then
	echo "Building version ${_grafana_version}"
	docker build \
		--build-arg GRAFANA_URL="https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${_grafana_version}.linux-x64.tar.gz" \
		--build-arg GF_UID="$_grafana_uid" \
		--build-arg GF_GID="$_grafana_gid" \
		--tag "${_docker_repo}:${_grafana_version}" \
		--no-cache=true .
	docker tag ${_docker_repo}:${_grafana_version} ${_docker_repo}:latest
else
	echo "Building latest for master"
	docker build \
		--tag "grafana/grafana:master" \
		.
fi
