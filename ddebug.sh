#!/bin/sh

set -e

CONTAINER_ID="$1"
IMAGE="${2:-alpine:3.6}"

if [ -z "$CONTAINER_ID" ]; then
	echo "Usage: $0 container_id [image]"
	exit 1
fi

jqcmd='jq'
if ! which "$jqcmd"; then
	jqcmd='docker run -i --rm munnerz/ddebug jq'
fi

jqpath='.[0].GraphDriver.Data.MergedDir'
rootfs_path=""
get_rootfs() {
	jsonOutput=$(docker inspect $CONTAINER_ID)
	if ! $!; then
		echo "Error inspecting container '$CONTAINER_ID'"
		exit 1
	fi
	rootfs_path=$(echo $jsonOutput | $jqcmd -r $jqpath)
	if ! $!; then
		echo "Error parsing container info for '$CONTAINER_ID'"
		exit 1
	fi
}
get_rootfs

exec docker run -it --rm \
		-v $rootfs_path:/containerfs \
		--net=container:$CONTAINER_ID \
		--pid=container:$CONTAINER_ID \
		--ipc=container:$CONTAINER_ID \
		--volumes-from=$CONTAINER_ID \
		"$IMAGE" \
		sh
