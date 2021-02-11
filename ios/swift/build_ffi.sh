#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
cd "${SCRIPT_DIR}"/../../

if [[ -n "${DEVELOPER_SDK_DIR:-}" ]]; then
  # Assume we're in Xcode, which means we're probably cross-compiling.
  # In this case, we need to add an extra library search path for build scripts and proc-macros,
  # which run on the host instead of the target.
  # (macOS Big Sur does not have linkable libraries in /usr/lib/.)
  export LIBRARY_PATH="${DEVELOPER_SDK_DIR}/MacOSX.sdk/usr/lib:${LIBRARY_PATH:-}"
fi

cargo build -p libbrotli-ffi --release
FFI_HEADER_PATH=ios/swift/Sources/BrotliFfi/brotli_ffi.h

cbindgen --profile release --lang c -o "${FFI_HEADER_PATH}" ffi
