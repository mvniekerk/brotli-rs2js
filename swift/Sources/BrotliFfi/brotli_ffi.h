#include <cstdarg>
#include <cstdint>
#include <cstdlib>
#include <ostream>
#include <new>

extern "C" {

const uint8_t *brotli_compress(unsigned char *cvec, unsigned int len, unsigned int *ret_array_len);

const uint8_t *brotli_decompress(unsigned char *cvec,
                                 unsigned int len,
                                 unsigned int *ret_array_len);

} // extern "C"
