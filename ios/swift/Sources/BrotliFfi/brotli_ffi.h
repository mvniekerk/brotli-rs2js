#include <cstdarg>
#include <cstdint>
#include <cstdlib>
#include <ostream>
#include <new>

extern "C" {

const char *brotli_compress_base64(const char *s);

const char *brotli_decompress_base64(const char *s);

void brotli_free_string(char *s);

} // extern "C"
