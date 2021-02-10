FROM rust:1.48 as rustbuild
RUN cargo install cargo-ndk
RUN rustup +nightly target add \
    aarch64-linux-android \
    armv7-linux-androideabi \
    x86_64-linux-android \
    i686-linux-android
RUN cargo install cbindgen
RUN mkdir /project
WORKDIR /project
COPY . /project


FROM ubuntu:20.04
RUN apt update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/London" apt install -y build-essential git cmake python3 && apt clean
WORKDIR /
RUN git clone https://github.com/WebAssembly/binaryen.git
WORKDIR /binaryen
RUN cmake . && make && mkdir /pkg
WORKDIR /
#RUN git clone https://github.com/WebAssembly/wabt.git
#WORKDIR /wabt
#RUN git submodule update --init
#RUN mkdir build && cd build && cmake ../ && cmake --build . && find .


COPY --from=rustbuild /project/pkg /pkg
WORKDIR /pkg
#RUN /wabt/build/wasm2wat brotli_rs2js_bg.wasm -o brotli_rs2js_bg.wat
#RUN /wabt/build/wasm-validate brotli_rs2js_bg.wasm
RUN /binaryen/bin/wasm2js brotli_rs2js_bg.wasm -o brotli_rs2js_bg1.js
RUN sed -i 's/brotli_rs2js_bg.wasm/brotli_rs2js_bg1.js/' brotli_rs2js.js
