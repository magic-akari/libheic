#import "libheic.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>

typedef NS_ENUM(NSInteger, ImageConversionError) {
    ImageConversionErrorLoadingImageFailed,
    ImageConversionErrorCreatingDestinationFailed,
    ImageConversionErrorFinalizingDestinationFailed
};

NSError* errorWithCode(ImageConversionError code) {
    NSString* domain = @"github.com/magic-akari/libheic";
    NSString* description;

    switch (code) {
        case ImageConversionErrorLoadingImageFailed:
            description = @"Cannot load image data.";
            break;
        case ImageConversionErrorCreatingDestinationFailed:
            description = @"Cannot create image destination.";
            break;
        case ImageConversionErrorFinalizingDestinationFailed:
            description = @"Cannot finalize HEIC data.";
            break;
    }

    return [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
}

NSData* convertImageToHEIC(NSData* imageData, CGFloat quality, NSError** error) {
    // Create a CGImageSource from NSData
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (!imageSource) {
        if (error) {
            *error = errorWithCode(ImageConversionErrorLoadingImageFailed);
        }
        return nil;
    }

    CFDictionaryRef imageProperties = CGImageSourceCopyProperties(imageSource, NULL);
    size_t imageCount = CGImageSourceGetCount(imageSource);

    // Create a mutable data object to hold the HEIC data
    NSMutableData* heicData = [NSMutableData data];

    // Create a CGImageDestination to write to the mutable data
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData(
        (__bridge CFMutableDataRef)heicData, (CFStringRef)AVFileTypeHEIC, imageCount, NULL);
    if (!imageDestination) {
        CFRelease(imageProperties);
        CFRelease(imageSource);
        if (error) {
            *error = errorWithCode(ImageConversionErrorCreatingDestinationFailed);
        }
        return nil;
    }

    // Set properties for the destination
    CGImageDestinationSetProperties(imageDestination, imageProperties);

    // Add images to the destination
    for (size_t index = 0; index < imageCount; index++) {
        CGImageDestinationAddImageFromSource(
            imageDestination, imageSource, index,
            (__bridge CFDictionaryRef)
                @{(NSString*)kCGImageDestinationLossyCompressionQuality : @(quality)});
    }

    // Finalize the destination
    if (!CGImageDestinationFinalize(imageDestination)) {
        CFRelease(imageDestination);
        CFRelease(imageProperties);
        CFRelease(imageSource);
        if (error) {
            *error = errorWithCode(ImageConversionErrorFinalizingDestinationFailed);
        }
        return nil;
    }

    // Clean up
    CFRelease(imageDestination);
    CFRelease(imageProperties);
    CFRelease(imageSource);

    return heicData;
}
