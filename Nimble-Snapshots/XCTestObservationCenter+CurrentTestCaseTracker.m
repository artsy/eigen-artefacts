#import "XCTestObservationCenter+CurrentTestCaseTracker.h"
#import "Nimble_Snapshots-Swift.h"

@implementation XCTestObservationCenter (CurrentTestCaseTracker)

+ (void)load {
    [[self sharedTestObservationCenter] addTestObserver:[CurrentTestCaseTracker shared]];
}

@end
