//
//  BTRippleButtton.m
//  BTSimpleRippleButton
//
//  Created by Balram Tiwari on 01/06/14.
//  Copyright (c) 2014 Balram. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "WYTinderSwipeRippleButtton.h"
#import "Masonry.h"

@implementation WYTinderSwipeRippleButtton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)commonInitWithImage:(UIImage *)image andFrame:(CGRect) frame{
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 3;
    imageView.layer.cornerRadius = imageView.frame.size.height/2;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:gesture];
    
}

- (instancetype)initWithImage:(UIImage *)image
                    andFrame:(CGRect)frame
                   andTarget:(SEL)action
                       andID:(id)sender {
    self = [super initWithFrame:frame];
    
    if(self){
        [self commonInitWithImage:image andFrame:frame];
        methodName = action;
        superSender = sender;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame onCompletion:(completion)completionBlock {
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self commonInitWithImage:image andFrame:frame];
        self.block = completionBlock;
    }
    
    return self;
}

- (void)loadImage:(UIImage *)image {
    imageView.image = image;
}

- (void)triggleAnimation {
    [self handleTap:nil withAction:NO];
}

- (void)setRippleEffectWithColor:(UIColor *)color {
    rippleColor = color;
}

- (void)setRippeEffectEnabled:(BOOL)enabled {
    isRippleOn = enabled;
}

- (void)setRippleEffectWithBGColor:(UIColor *)color {
    rippleBGColor = color;
}

- (void)handleTap:(id)sender {
    [self handleTap:sender withAction:YES];
}

- (void)handleTap:(id)sender withAction:(BOOL)isAction {
    if(isNextDismiss && !isAction) {
        isNextDismiss = NO;
        return;
    } else if(isAction) {
        isNextDismiss = YES;
    }
    
    if (isRippleOn) {
        UIColor *stroke = rippleColor ? rippleColor : [UIColor colorWithWhite:0.8 alpha:0.8];
        UIColor *fillColor = rippleBGColor ? rippleBGColor : [UIColor colorWithWhite:0.8 alpha:0.1];
        
        CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
        
        // accounts for left/right offset and contentOffset of scroll view
        CGPoint shapePosition = containerView.center;
        
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = fillColor.CGColor;
        circleShape.opacity = 0;
        circleShape.strokeColor = stroke.CGColor;
        circleShape.lineWidth = 1;
        
        [containerView.layer addSublayer:circleShape];
        
        
        [CATransaction begin];
        //remove layer after animation completed
        [CATransaction setCompletionBlock:^{
            [circleShape removeFromSuperlayer];
        }];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.5, 3.5, 1)];
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[scaleAnimation, alphaAnimation];
        animation.duration = 2.0f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [circleShape addAnimation:animation forKey:nil];
        
        [CATransaction commit];
    }
    gesture.enabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if(isAction) {
            imageView.transform = CGAffineTransformMakeScale(1.15, 1.15);
        }
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            gesture.enabled = YES;
            if(isAction) {
                imageView.transform = CGAffineTransformMakeScale(1, 1);
            }
        }completion:^(BOOL finished) {
            if(isAction && [superSender respondsToSelector:methodName]){
                [superSender performSelectorOnMainThread:methodName withObject:nil waitUntilDone:NO];
            }
            
            if(_block && isAction) {
                BOOL success= YES;
                _block(success);
            }
        }];
        
    }];
}



@end
