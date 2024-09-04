#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>

@interface HEIC : NSObject
+ (NSData*)encodeImage:(NSData*)image withQuality:(CGFloat)quality error:(NSError**)error;
@end
