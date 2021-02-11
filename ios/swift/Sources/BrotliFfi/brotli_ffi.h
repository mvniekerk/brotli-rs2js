#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

const char *brotli_compress_base64(const char *s);

const char *brotli_decompress_base64(const char *s);

void brotli_free_string(char *s);
