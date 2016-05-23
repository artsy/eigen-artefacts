#import <Foundation/Foundation.h>

@interface Message : NSObject

- (instancetype)initWithName:(NSString *)name content:(NSString *)content;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *content;

@end
