#import "ARLoadFailureView.h"

#import "UILabel+Typography.h"

#if __has_include(<Artsy+UIFonts/UIFont+ArtsyFonts.h>)
#import <Artsy-UIButtons/ARButtonSubclasses.h>
#import <Artsy+UIColors/UIColor+ArtsyColors.h>
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import <FLKAutoLayout/FLKAutoLayout.h>
#import <ORStackView/ORStackView.h>
#import <objc/message.h>
#else
@import Artsy_UIButtons;
@import Artsy_UIColors;
@import Artsy_UIFonts;
@import FLKAutoLayout;
@import ORStackView;
//@import objc;
#endif


@interface ARLoadFailureView ()
@property (readonly, nonatomic, strong) ARMenuButton *retryButton;
@property (readwrite, nonatomic, assign) BOOL shouldRotate;
@end


@implementation ARLoadFailureView

- (instancetype)initWithFrame:(CGRect)frame;
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor whiteColor];
    
    ORStackView *stackView = [ORStackView new];
    stackView.backgroundColor = [UIColor whiteColor];

    // Copy of ARSansSerifHeaderLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.opaque = YES;
    titleLabel.textColor = [UIColor artsyGraySemibold];
    titleLabel.font = [UIFont sansSerifFontWithSize:self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular ? 25 : 18];
    [stackView addSubview:titleLabel
            withTopMargin:self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular ? @"50" : @"20"
               sideMargin:@"120"];
    [titleLabel setText:@"UNABLE TO LOAD"
      withLetterSpacing:self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular ? 1.9 : 0.5];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.backgroundColor = [UIColor whiteColor];
    subtitleLabel.opaque = YES;
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont serifFontWithSize:16];
    subtitleLabel.textColor = [UIColor artsyGraySemibold];
    [stackView addSubview:subtitleLabel withTopMargin:@"8" sideMargin:@"48"];
    subtitleLabel.text = @"Please try again";

    UIImage *buttonIcon = [UIImage imageNamed:@"ARLoadFailureRetryIcon"
                                     inBundle:[NSBundle bundleForClass:self.class]
                compatibleWithTraitCollection:nil];
    _retryButton = [ARMenuButton new];
    [_retryButton setBorderColor:[UIColor artsyGrayRegular] forState:UIControlStateNormal animated:NO];
    [_retryButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal animated:NO];
    [_retryButton setImage:buttonIcon forState:UIControlStateNormal];
    [_retryButton addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
    _retryButton.adjustsImageWhenDisabled = NO;
    
    UIView *buttonContainer = [UIView new];
    [buttonContainer addSubview:_retryButton];
    [buttonContainer constrainHeightToView:_retryButton predicate:@"0"];
    [_retryButton alignCenterWithView:buttonContainer];
    [stackView addSubview:buttonContainer withTopMargin:@"20" sideMargin:@"0"];
    
    [self addSubview:stackView];
    [stackView alignCenterWithView:self];
  }
  return self;
}

- (IBAction)retry:(id)sender;
{
  self.shouldRotate = YES;
  [self rotate];
  [self.delegate loadFailureViewDidRequestRetry:self];
}

// Only need to rotate half way, because the icon is symetrical.
- (void)rotate;
{
  self.retryButton.transform = CGAffineTransformIdentity;
  __weak __typeof(self) weakSelf = self;
  [UIView animateKeyframesWithDuration:1.0
                                 delay:0.0
                               options:UIViewKeyframeAnimationOptionCalculationModePaced | UIViewAnimationOptionCurveLinear
                            animations:^{
                              [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.0 animations:^{
                                weakSelf.retryButton.transform = CGAffineTransformMakeRotation(M_PI * 2.0 / 3.0);
                              }];
                              [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.0 animations:^{
                                weakSelf.retryButton.transform = CGAffineTransformMakeRotation(M_PI * 4.0 / 3.0);
                              }];
                              [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.0 animations:^{
                                weakSelf.retryButton.transform = CGAffineTransformIdentity;
                              }];
                            }
                            completion:^(BOOL _) {
                              __strong __typeof(weakSelf) strongSelf = weakSelf;
                              if (strongSelf && strongSelf.shouldRotate) [strongSelf rotate];
                            }];
}

// Don’t immediately stop the animation, instead let it do a full rotation so that the user has the feeling we at least
// tried when a connection fails immediately again.
- (void)retryFailed;
{
  self.shouldRotate = NO;
}

@end
