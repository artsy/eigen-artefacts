#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AFOAuth1Client.h"
#import "AFOAuth1RequestSerializer.h"
#import "AFOAuth1Token.h"
#import "AFOAuth1Utils.h"

FOUNDATION_EXPORT double AFOAuth1ClientVersionNumber;
FOUNDATION_EXPORT const unsigned char AFOAuth1ClientVersionString[];

