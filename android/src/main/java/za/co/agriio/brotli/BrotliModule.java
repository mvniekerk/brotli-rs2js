package za.co.agriio.brotli;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class BrotliModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public BrotliModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "Brotli";
    }

    @ReactMethod
    public void compress(String base64Buf, Callback callback) {
        callback.invoke("");
    }

    @ReactMethod
    public void decompress(String base64Buf, Callback callback) {
        callback.invoke("");
    }
}
