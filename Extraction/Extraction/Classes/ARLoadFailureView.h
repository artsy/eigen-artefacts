#import <UIKit/UIKit.h>

@class ARLoadFailureView;

@protocol ARLoadFailureViewDelegate
- (void)loadFailureViewDidRequestRetry:(ARLoadFailureView *)loadFailureView;
@end


@interface ARLoadFailureView : UIView

@property (readwrite, nonatomic, weak) id<ARLoadFailureViewDelegate> delegate;

- (void)retryFailed;

@end
