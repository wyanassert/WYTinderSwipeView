//
//  BTRippleButtton.h
//  BTSimpleRippleButton
//
//  Created by Balram Tiwari on 01/06/14.
//  Copyright (c) 2014 Balram. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completion)(BOOL success);

@interface WYTinderSwipeRippleButtton : UIView{
    @private
    UIImageView *imageView;
    UILabel *title;
    UITapGestureRecognizer *gesture;
    SEL methodName;
    id superSender;
    UIColor *rippleColor;
    UIColor *rippleBGColor;
    NSArray *rippleColors;
    UIView *containerView;
    BOOL isRippleOn;
    BOOL isNextDismiss;
}

@property (nonatomic, copy) completion block;

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame andTarget:(SEL)action andID:(id)sender;

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame onCompletion:(completion)completionBlock;

- (void)loadImage:(UIImage *)image;

- (void)triggleAnimation;

- (void)setRippleEffectWithColor:(UIColor *)color;
- (void)setRippleEffectWithBGColor:(UIColor *)color;

- (void)setRippeEffectEnabled:(BOOL)setRippeEffectEnabled;

@end
