#import "Route.h"

@implementation Route

- (instancetype)initWithName:(NSString *)name path:(NSString *)path
{
    self = [super init];
    if (!self) return nil;

    _name = name;
    _path = path;
    return self;
}

@end
