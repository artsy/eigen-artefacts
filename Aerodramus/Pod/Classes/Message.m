#import "Message.h"

@implementation Message

- (instancetype)initWithName:(NSString *)name content:(NSString *)content
{
    self = [super init];
    if (!self) return nil;

    _name = name;
    _content = content;
    return self;
}

@end
