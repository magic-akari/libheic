#define NODE_ADDON_API_DISABLE_DEPRECATED
#include <napi.h>
#import "libheic.h"

Napi::Value encode(const Napi::CallbackInfo& info) {
    Napi::Env env = info.Env();

    if (info.Length() < 1) {
        Napi::TypeError::New(env, "arguments[0] is required").ThrowAsJavaScriptException();
        return env.Null();
    }

    Napi::ArrayBuffer buffer;
    if (info[0].IsArrayBuffer()) {
        buffer = info[0].As<Napi::ArrayBuffer>();
    } else if (info[0].IsTypedArray()) {
        Napi::TypedArray typed_array = info[0].As<Napi::TypedArray>();
        buffer = typed_array.ArrayBuffer();
    } else if (info[0].IsDataView()) {
        Napi::DataView data_view = info[0].As<Napi::DataView>();
        buffer = data_view.ArrayBuffer();
    } else {
        Napi::TypeError::New(env, "Expect arguments[0] to be an instance of ArrayBuffer, TypedArray or DataView")
            .ThrowAsJavaScriptException();
        return env.Null();
    }

    double quality = 0.8;
    if (info.Length() >= 2 && !info[1].IsUndefined()) {
        if (!info[1].IsNumber()) {
            Napi::TypeError::New(env, "arguments[1] must be a number").ThrowAsJavaScriptException();
            return env.Null();
        }
        quality = info[1].As<Napi::Number>().DoubleValue();
    }

    Napi::Value result;

    @autoreleasepool {
        NSData* input_image = [NSData dataWithBytes:buffer.Data() length:buffer.ByteLength()];
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

Napi::Value decode(const Napi::CallbackInfo& info) {
    Napi::Env env = info.Env();

    if (info.Length() < 1) {
        Napi::TypeError::New(env, "arguments[0] is required").ThrowAsJavaScriptException();
        return env.Null();
    }

    Napi::ArrayBuffer buffer;
    if (info[0].IsArrayBuffer()) {
        buffer = info[0].As<Napi::ArrayBuffer>();
    } else if (info[0].IsTypedArray()) {
        Napi::TypedArray typed_array = info[0].As<Napi::TypedArray>();
        buffer = typed_array.ArrayBuffer();
    } else if (info[0].IsDataView()) {
        Napi::DataView data_view = info[0].As<Napi::DataView>();
        buffer = data_view.ArrayBuffer();
    } else {
        Napi::TypeError::New(env, "Expect arguments[0] to be an instance of ArrayBuffer, TypedArray or DataView")
            .ThrowAsJavaScriptException();
        return env.Null();
    }

    Napi::Value result;
    @autoreleasepool {
        NSData* input_image = [NSData dataWithBytes:buffer.Data() length:buffer.ByteLength()];
        NSError* error = nil;

        NSData* output_image = [HEIC decodeImage:input_image error:&error];
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
    exports.Set(Napi::String::New(env, "decode"), Napi::Function::New(env, decode));

    return exports;
}

NODE_API_MODULE(addon, Init)
