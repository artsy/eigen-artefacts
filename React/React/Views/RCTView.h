/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTView.h"

#import <UIKit/UIKit.h>

#import "RCTBorderStyle.h"
#import "RCTComponent.h"
#import "RCTPointerEvents.h"

@protocol RCTAutoInsetsProtocol;

@class RCTView;


@protocol RCTClippableView;


/**
 * Having views in view hierarchy that are not visible wastes resources.
 * That's why we have implemented view clipping. The key idea is simple:
 *   When a view has clipping turned on, its subview is removed as long as it is outside of the view's bounds.
 * These following two protocols help achieving this behavior.
 * View that clips has to implement `RCTClippingView` protocol and a view that can be clipped `RCTClippableView` protocol.
 *
 * The parent (clipping) view is always responsible for doing the view manipulation.
 * If a clippable view changes its position it should notify it's clipping superview to redo the clipping using the `reclipView:` call.
 *
 * In some special cases the direct superview doesn't have the right size for clipping.
 * A scrollview is a nice example: Scrollview doesn't have rows as its direct subviews.
 * There is a content view between them whose bounds contain all rows. Therefore in this case clipping have to be done based not on a direct superview, but one above.
 *
 * This is enabled by calling `clippingRectForClippingView:`.
 * All clipping views should call this method during `reclipView:` on their parent to enable clipping rect override by parent. See implementation in `RCTView`.
 */
@protocol RCTClippingView <NSObject>
@property (nonatomic, assign) BOOL removeClippedSubviews;
- (void)reclipView:(UIView<RCTClippableView> *)clippableView;
- (CGRect)clippingRectForClippingView:(UIView<RCTClippingView> *)clippingView;
@end

/**
 * A view implementing this protocol can be clipped.
 */
@protocol RCTClippableView <NSObject>
/**
 * This property has to be set by a clipping parent when clipping is active.
 * Even if this view was clipped (it has no superview), this points to its parent view in the react hierarchy.
 * (That doesn't have to be true for `reactSuperview)
 */
@property (weak, nonatomic) UIView<RCTClippingView> *reactClippingSuperview;
@end

@interface RCTView : UIView <RCTClippingView, RCTClippableView>

/**
 * Accessibility event handlers
 */
@property (nonatomic, copy) RCTDirectEventBlock onAccessibilityTap;
@property (nonatomic, copy) RCTDirectEventBlock onMagicTap;

/**
 * Used to control how touch events are processed.
 */
@property (nonatomic, assign) RCTPointerEvents pointerEvents;

+ (void)autoAdjustInsetsForView:(UIView<RCTAutoInsetsProtocol> *)parentView
                 withScrollView:(UIScrollView *)scrollView
                   updateOffset:(BOOL)updateOffset;

/**
 * Find the first view controller whose view, or any subview is the specified view.
 */
+ (UIEdgeInsets)contentInsetsForView:(UIView *)curView;

/**
 * z-index, used to override sibling order in didUpdateReactSubviews. This is
 * inherited from UIView+React, but we override it here to reduce the boxing
 * and associated object overheads.
 */
@property (nonatomic, assign) NSInteger reactZIndex;


/**
 * Border radii.
 */
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, assign) CGFloat borderTopLeftRadius;
@property (nonatomic, assign) CGFloat borderTopRightRadius;
@property (nonatomic, assign) CGFloat borderBottomLeftRadius;
@property (nonatomic, assign) CGFloat borderBottomRightRadius;

/**
 * Border colors (actually retained).
 */
@property (nonatomic, assign) CGColorRef borderTopColor;
@property (nonatomic, assign) CGColorRef borderRightColor;
@property (nonatomic, assign) CGColorRef borderBottomColor;
@property (nonatomic, assign) CGColorRef borderLeftColor;
@property (nonatomic, assign) CGColorRef borderColor;

/**
 * Border widths.
 */
@property (nonatomic, assign) CGFloat borderTopWidth;
@property (nonatomic, assign) CGFloat borderRightWidth;
@property (nonatomic, assign) CGFloat borderBottomWidth;
@property (nonatomic, assign) CGFloat borderLeftWidth;
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * Border styles.
 */
@property (nonatomic, assign) RCTBorderStyle borderStyle;

/**
 *  Insets used when hit testing inside this view.
 */
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
