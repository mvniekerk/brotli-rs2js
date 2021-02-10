#include <cstdarg>
#include <cstdint>
#include <cstdlib>
#include <ostream>
#include <new>

template<typename T = void>
struct Vec;

extern "C" {

Vec<uint8_t> brotli_compress(const Vec<uint8_t> *buf);

Vec<uint8_t> brotli_decompress(const Vec<uint8_t> *arr);

} // extern "C"
