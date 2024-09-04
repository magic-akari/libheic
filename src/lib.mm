#define NODE_ADDON_API_DISABLE_DEPRECATED
#include <napi.h>
#import "libheic.h"

Napi::Value encode(const Napi::CallbackInfo& info) {
    Napi::Env env = info.Env();

    if (info.Length() < 1 || info.Length() > 2) {
        Napi::TypeError::New(env, "Only accepts 1 or 2 arguments").ThrowAsJavaScriptException();
        return env.Null();
    }

    if (!info[0].IsArrayBuffer()) {
        Napi::TypeError::New(env, "arguments[0] must be an ArrayBuffer").ThrowAsJavaScriptException();
        return env.Null();
    }

    double quality = 0.8;
    if (info.Length() == 2 && !info[1].IsUndefined()) {
        if (!info[1].IsNumber()) {
            Napi::TypeError::New(env, "arguments[1] must be a number").ThrowAsJavaScriptException();
            return env.Null();
        }
        quality = info[1].As<Napi::Number>().DoubleValue();
    }

    auto buffer = info[0].As<Napi::ArrayBuffer>();

    size_t length = buffer.ByteLength();
    void* bytes = buffer.Data();

    Napi::Value result;

    @autoreleasepool {
        NSData* input_image = [NSData dataWithBytes:bytes length:length];
        NSError* error = nil;

        NSData* output_image = [HEIC encodeImage:input_image withQuality:(CGFloat)quality error:&error];
        if (error) {
            Napi::Error::New(env, error.localizedDescription.UTF8String).ThrowAsJavaScriptException();
            return env.Null();
        }

        Napi::ArrayBuffer output_buffer = Napi::ArrayBuffer::New(env, output_image.length);
        memcpy(output_buffer.Data(), output_image.bytes, output_image.length);
        result = output_buffer;
    }

    return result;
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
    exports.Set(Napi::String::New(env, "encode"), Napi::Function::New(env, encode));

    return exports;
}

NODE_API_MODULE(addon, Init)
