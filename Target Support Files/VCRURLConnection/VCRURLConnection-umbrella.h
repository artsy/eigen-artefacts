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

#import "NSData+Base64.h"
#import "VCR+NSURLSessionConfiguration.h"
#import "VCR.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"
#import "VCRCassette_Private.h"
#import "VCRError.h"
#import "VCROrderedMutableDictionary.h"
#import "VCRRecording.h"
#import "VCRRecordingURLProtocol.h"
#import "VCRReplayingURLProtocol.h"
#import "VCRRequestKey.h"

FOUNDATION_EXPORT double VCRURLConnectionVersionNumber;
FOUNDATION_EXPORT const unsigned char VCRURLConnectionVersionString[];

