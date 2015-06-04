#!/bin/bash
for i in "$@"
do
case $i in
    -g=*|--gateway=*)
    GATEWAY="${i#*=}"
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done
# Configure to use the transparent proxy
route del default
route add default gw ${GATEWAY}

