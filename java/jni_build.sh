SCRIPT_DIR=$(dirname "$0")
cd "${SCRIPT_DIR}"/../java

copy_built_library() {
  for possible_library_name in "lib$2.dylib" "lib$2.so" "$2.dll"; do
    possible_library_path="$1/${possible_library_name}"
    if [ -e "${possible_library_path}" ]; then
      out_dir=$(dirname "$3"x)
      echo_then_run mkdir -p "${out_dir}"
      echo_then_run cp "${possible_library_path}" "$3"
      break
    fi
  done
}

for i in 'aarch64-linux-android' 'armv7-linux-androideabi' 'i686-linux-android' 'x86_64-linux-android'; do
  echo $i
  cd ../jni
  cargo ndk --target $i --platform 23 -- build --release
  cd ../java
  mkdir -p android/src/main/jniLibs/$i
  cp ../target/$i/release/libbrotli_jni.so android/src/main/jniLibs/$i/
done


