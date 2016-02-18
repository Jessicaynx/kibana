#!/bin/bash
exec "$@"
service kibana start
service nginx start
