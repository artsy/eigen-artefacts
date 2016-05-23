#import <Foundation/Foundation.h>

@interface Route : NSObject

- (instancetype)initWithName:(NSString *)name path:(NSString *)path;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;

@end
