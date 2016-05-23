@import Foundation;

#if __has_feature(objc_generics)
#define NSArrayOf(x) NSArray<x>
#define NSDictionaryOf(x,y) NSDictionary<x, y>
#else
#define NSArrayOf(x) NSArray
#define NSDictionaryOf(x,y) NSDictionary
#endif

#import "Route.h"
#import "Feature.h"
#import "Message.h"
#import "AeroRouter.h"

NS_ASSUME_NONNULL_BEGIN

@class Route, Feature, Message;

/// A class to communicate with the Artsy Echo API
/// @see Web Interface: https://echo-web-production.herokuapp.com/
/// @see Heroku Settings URL: https://dashboard.heroku.com/apps/echo-web-production/settings

@interface Aerodramus : NSObject

/// Creates an instance of Aerodramus hooked up to an echo URL
/// It will look in the user's document dir for [filename].json
/// and then fall back to looking inside the App bundle.

- (instancetype)initWithServerURL:(NSURL *)url accountID:(NSInteger)accountID APIKey:(NSString *)APIKey localFilename:(NSString *)filename;

/// Grabs the local JSON and sets itself up
- (void)setup;

/// Does a HEAD request against the server comparing the local date with the last changed
- (void)checkForUpdates:(void (^)(BOOL updatedDataOnServer))updateCheckCompleted;

/// Updates the local instance with data from the server
- (void)update:(void (^)(BOOL updated, NSError * _Nullable error))completed;

/// The Echo account name for this app
@property (nonatomic, nonnull, copy) NSString *name;

/// The Echo account ID for this app
@property (nonatomic, assign) NSInteger accountID;

/// The time when this instance of Aerodramus was last updated
@property (nonatomic, nonnull, strong) NSDate *lastUpdatedDate;

/// Collection of routes from the echo server
@property (nonatomic, nonnull, copy) NSDictionaryOf(NSString *, Route *) *routes;

/// Collection of boolean feature switches from the echo server
@property (nonatomic, nonnull, copy) NSDictionaryOf(NSString *, Feature *) *features;

/// Collection of messages from the echo server
@property (nonatomic, nonnull, copy) NSArrayOf(Message *) *messages;

@end

NS_ASSUME_NONNULL_END