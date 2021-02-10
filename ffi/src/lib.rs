
use brotli::CompressorWriter;
use bytes::BufMut;
use std::io::{Read, Write};
use bytes::Buf;

#[no_mangle]
pub extern "C" fn brotli_compress(buf: &Vec<u8>) -> Vec<u8> {
    // (false, buf.clone())
    let compressed_buf = Vec::with_capacity(buf.len());
    let mut w = compressed_buf.writer();
    let mut c = CompressorWriter::new(&mut w, 4096, 11, 22);
    let wa = c.write_all(buf.as_slice()).map_err(|_| ());
    if wa.is_err() {
        return buf.clone();
    }
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
}

pub fn brotli_copy<R: Read, W: Write>(source: R, mut dest: W) -> std::io::Result<u64> {
    let mut decoder = brotli::Decompressor::new(source, 4096);
    std::io::copy(&mut decoder, &mut dest)
}

#[no_mangle]
pub extern "C" fn brotli_decompress(arr: &Vec<u8>) -> Vec<u8> {
    let buf = Vec::with_capacity(arr.len());
    let mut w = buf.writer();
    let cpy = brotli_copy(arr.reader(), &mut w).map_err(|_| ());
    if cpy.is_err() {
        return vec![];
    }
    w.get_ref().to_vec()
}