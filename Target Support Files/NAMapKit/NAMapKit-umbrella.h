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

#import "NAAnnotation.h"
#import "NADotAnnotation.h"
#import "NAMapView.h"
#import "NAMapViewDelegate.h"
#import "NAPinAnnotation.h"
#import "NAPinAnnotationCallOutView.h"
#import "NAPinAnnotationMapView.h"
#import "NAPinAnnotationView.h"
#import "NATiledImageMapView.h"

FOUNDATION_EXPORT double NAMapKitVersionNumber;
FOUNDATION_EXPORT const unsigned char NAMapKitVersionString[];

