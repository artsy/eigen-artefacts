#import "Feature.h"

@implementation Feature

- (instancetype)initWithName:(NSString *)name state:(NSNumber *)state
{
    self = [super init];
    if (!self) return nil;

    _name = name;
    _state = state.boolValue;
    return self;
}

@end
