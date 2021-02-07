mod utils;

use wasm_bindgen::prelude::*;
use js_sys::Uint8Array;
use brotli::CompressorWriter;
use bytes::BufMut;
use wasm_bindgen::__rt::std::io::{Write, Read};

// When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
// allocator.
#[cfg(feature = "wee_alloc")]
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

#[wasm_bindgen]
extern {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet() {
    alert("Hello, brotli-rs2js!");
}

fn brotli_compress(buf: &Vec<u8>) -> Result<Vec<u8>, JsValue> {
    // (false, buf.clone())
    let compressed_buf = Vec::with_capacity(buf.len());
    let mut w = compressed_buf.writer();
    let mut c = CompressorWriter::new(&mut w, 4096, 11, 22);
    c.write_all(buf.as_slice()).map_err(|_| JsValue::from_str("Could not write"))?;
    Ok(
        c.flush()
            .map(|_| {
                let c = c.into_inner();
                if c.get_ref().len() < buf.len() {
                    c.get_ref().to_vec()
                } else {
                    buf.clone()
                }
            })
            .unwrap_or(buf.clone())
    )
}


pub fn brotli_copy<R: Read, W: Write>(source: R, mut dest: W) -> std::io::Result<u64> {
    let mut decoder = brotli::Decompressor::new(source, 4096);
    std::io::copy(&mut decoder, &mut dest)
}

#[wasm_bindgen]
pub fn compress(arr: Uint8Array) -> Result<Uint8Array, JsValue> {
    let arr = arr.to_vec();
    let ret = brotli_compress(&arr)?;
    let ret = ret.as_slice();
    Ok(Uint8Array::from(ret))
}

#[wasm_bindgen]
pub fn decompress(arr: Uint8Array) -> Result<Uint8Array, JsValue> {
    use bytes::Buf;

    let ret = arr.to_vec();
    let buf = Vec::with_capacity(arr.length() as usize);
    let mut w = buf.writer();
    brotli_copy(ret.reader(), &mut w).map_err(|_| JsValue::from_str("Could not decode"))?;
    let ret = w.get_ref().to_vec();
    let ret = ret.as_slice();
    Ok(Uint8Array::from(ret))
}
