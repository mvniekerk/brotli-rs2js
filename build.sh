#!/bin/sh
rm -rf lib
docker build -t brotli-rs2js .
docker run --name brotli-r2js-build brotli-rs2js exit 0
mkdir lib
docker cp brotli-r2js-build:/pkg lib/
