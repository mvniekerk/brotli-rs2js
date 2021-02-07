FROM rust:1.48 as rustbuild
RUN rustup target add wasm32-unknown-unknown && cargo install wasm-pack
RUN mkdir /project
WORKDIR /project
COPY . /project
RUN wasm-pack build

FROM ubuntu:20.04
RUN apt update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/London" apt install -y build-essential git cmake python3 && apt clean
WORKDIR /
RUN git clone https://github.com/WebAssembly/binaryen.git
WORKDIR /binaryen
RUN cmake . && make && mkdir /pkg
COPY --from=rustbuild /project/pkg /pkg
WORKDIR /pkg
RUN find . && /binaryen/bin/wasm2js brotli_rs2js_bg.wasm -o brotli.js
