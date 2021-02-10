/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package za.co.agriio.brotli;
import java.io.InputStream;
import java.nio.file.Files;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.IOException;

public class Native {
    private static void copyToTempFileAndLoad(InputStream in, String extension) throws IOException {
        File tempFile = Files.createTempFile("resource", extension).toFile();
        tempFile.deleteOnExit();

        try (OutputStream out = new FileOutputStream(tempFile)) {
            byte[] buffer = new byte[4096];
            int read;

            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
        }
        System.load(tempFile.getAbsolutePath());
    }

    private static void loadLibrary() {
        try {
            String  osName    = System.getProperty("os.name").toLowerCase(java.util.Locale.ROOT);
            boolean isMacOs   = osName.startsWith("mac os");
            String  extension = isMacOs ? ".dylib" : ".so";

            try (InputStream in = Native.class.getResourceAsStream("/libbrotli_jni" + extension)) {
                if (in != null) {
                    copyToTempFileAndLoad(in, extension);
                } else {
                    System.loadLibrary("brotli_jni");
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    static {
        loadLibrary();
    }

    private Native() {}

    public static native byte[] compress(byte[] data);
    public static native byte[] decompress(byte[] data);
}
