import l, { InitOutput } from '../lib/index.js';
function unicodeStringToTypedArray(s: string): Uint8Array {
    const escstr = encodeURIComponent(s);
    const binstr = escstr.replace(/%([0-9A-F]{2})/g, function (match, p1) {
        return String.fromCharCode(Number('0x' + p1));
    });
    const ua = new Uint8Array(binstr.length);
    Array.prototype.forEach.call(binstr, function (ch, i) {
        ua[i] = ch.charCodeAt(0);
    });
    return ua;
}

function typedArrayToUnicodeString(ua: Uint8Array) {
    const binstr = Array.prototype.map.call(ua, function (ch) {
        return String.fromCharCode(ch);
    }).join('');
    const escstr = binstr.replace(/(.)/g, function (m, p) {
        let code = p.charCodeAt(p).toString(16).toUpperCase();
        if (code.length < 2) {
            code = '0' + code;
        }
        return '%' + code;
    });
    return decodeURIComponent(escstr);
}


describe('Compress and decompress a bunch of bytes', () => {
    it('Compress a jwt array, and decompress it afterwards', async () => {
        const jwt = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
        const jwt_array = unicodeStringToTypedArray(jwt);
        const { compress, decompress } = l.instance;
        const jwt_compressed = compress(jwt_array);
        const jwt_decompressed = decompress(jwt_compressed);
        const jwt_after_brotli = typedArrayToUnicodeString(jwt_decompressed);
        expect(jwt_after_brotli).not.toBe(undefined);
        expect(jwt_compressed).not.toEqual(jwt_array);
        expect(jwt_after_brotli).toEqual(jwt);
        expect(jwt_decompressed).toEqual(jwt_array);
    })

});
