use jni::objects::JClass;
use jni::sys::jbyteArray;
use jni::JNIEnv;
use libbrotli_ffi::{brotli_compress, brotli_decompress};

#[no_mangle]
pub unsafe extern "C" fn Java_za_co_agriio_brotli_Native_compress(
    env: JNIEnv,
    _class: JClass,
    data: jbyteArray,
) -> jbyteArray {
    let data = env.convert_byte_array(data).unwrap();
    let data = brotli_compress(&data).unwrap_or(vec![]);
    let ret = env.byte_array_from_slice(&data).unwrap();
    ret
}

#[no_mangle]
pub unsafe extern "C" fn Java_za_co_agriio_brotli_Native_decompress(
    env: JNIEnv,
    _class: JClass,
    data: jbyteArray,
) -> jbyteArray {
    let data = env.convert_byte_array(data).unwrap();
    let data = brotli_decompress(&data).unwrap_or(vec![]);
    let ret = env.byte_array_from_slice(&data).unwrap();
    ret
}
