
use brotli::CompressorWriter;
use bytes::BufMut;
use std::io::{Read, Write};
use bytes::Buf;
use c_vec::CVec;

pub fn brotli_compress_rs(buf: &Vec<u8>) -> Vec<u8> {
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

#[no_mangle]
pub extern "C" fn brotli_compress(cvec: *mut libc::c_uchar, len: libc::c_uint, ret_array_len: *mut libc::c_uint) -> *const u8 {
    let buf = unsafe { CVec::new(cvec, len as usize) };
    let buf = buf.as_ref().to_vec();
    let ret = brotli_compress_rs(&buf);
    let ret_len = ret.len();
    let ret = Box::new(&ret);
    let ret = Box::into_raw(ret) as *const _;
    unsafe { *ret_array_len = ret_len as libc::c_uint; };
    ret
}

pub fn brotli_copy<R: Read, W: Write>(source: R, mut dest: W) -> std::io::Result<u64> {
    let mut decoder = brotli::Decompressor::new(source, 4096);
    std::io::copy(&mut decoder, &mut dest)
}

#[no_mangle]
pub extern "C" fn brotli_decompress(cvec: *mut libc::c_uchar, len: libc::c_uint, ret_array_len: *mut libc::c_uint) -> *const u8 {
    let buf = unsafe { CVec::new(cvec, len as usize) };
    let buf = buf.as_ref().to_vec();
    let ret = brotli_decompress_rs(&buf);
    let ret_len = ret.len();
    let ret = Box::new(&ret);
    let ret = Box::into_raw(ret) as *const _;
    unsafe { *ret_array_len = ret_len as libc::c_uint; };
    ret
}

pub fn brotli_decompress_rs(arr: &Vec<u8>) -> Vec<u8> {
    let buf = Vec::with_capacity(arr.len());
    let mut w = buf.writer();
    let cpy = brotli_copy(arr.reader(), &mut w).map_err(|_| ());
    if cpy.is_err() {
        return vec![];
    }
    w.get_ref().to_vec()
}
