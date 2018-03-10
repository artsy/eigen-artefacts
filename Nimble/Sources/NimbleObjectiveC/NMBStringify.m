#import "NMBStringify.h"
#import "Nimble-Swift.h"

NSString *_Nonnull NMBStringify(id _Nullable anyObject) {
    return [NMBStringer stringify:anyObject];
}
