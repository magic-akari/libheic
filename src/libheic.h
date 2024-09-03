#ifndef LIBHEIC_H
#define LIBHEIC_H

#import <Foundation/Foundation.h>

NSData* convertImageToHEIC(NSData* imageData, CGFloat quality, NSError** error);

#endif  // LIBHEIC_H