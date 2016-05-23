#import <Foundation/Foundation.h>

@interface Feature : NSObject

- (instancetype)initWithName:(NSString *)name state:(NSNumber *)state;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) BOOL state;

@end
