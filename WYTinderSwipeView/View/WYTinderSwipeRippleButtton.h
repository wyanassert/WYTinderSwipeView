//
//  WYTinderSwipeRippleButtton.h
//  Neon
//
//  Created by wyan assert on 2017/11/14.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WYTinderSwipeRippleButttonCompletion)(BOOL success);

@interface WYTinderSwipeRippleButtton : UIView

@property (nonatomic, copy) WYTinderSwipeRippleButttonCompletion block;

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame andTarget:(SEL)action andID:(id)sender;
- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame onCompletion:(WYTinderSwipeRippleButttonCompletion)completionBlock;

- (void)loadImage:(UIImage *)image;
- (void)triggleAnimation;

- (void)setRippleEffectWithColor:(UIColor *)color;
- (void)setRippleEffectWithBGColor:(UIColor *)color;
- (void)setRippeEffectEnabled:(BOOL)setRippeEffectEnabled;

@end
