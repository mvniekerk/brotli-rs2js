#!/bin/sh
rm -rf brotli-lib
docker build -t brotli-rs2js .
docker rm brotli-r2js-build
docker run --name brotli-r2js-build brotli-rs2js echo 0
mkdir brotli-lib
docker cp brotli-r2js-build:/pkg brotli-lib
docker rm brotli-r2js-build
rm -rf lib
mkdir lib
cp brotli-lib/pkg/brotli* brotli-lib/pkg/index* lib/
cp lib/brotli_rs2js.d.ts lib/index.d.ts
