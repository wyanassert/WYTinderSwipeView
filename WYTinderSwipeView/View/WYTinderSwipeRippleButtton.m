//
//  WYTinderSwipeRippleButtton.h
//  Neon
//
//  Created by wyan assert on 2017/11/14.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Masonry.h"

#import "WYTinderSwipeRippleButtton.h"

@interface WYTinderSwipeRippleButtton()

@property (nonatomic, strong) UIImageView            *imageView;
@property (nonatomic, strong) UIImage                *image;
@property (nonatomic, strong) UITapGestureRecognizer *gesture;
@property (nonatomic, strong) UIView                 *containerView;

@property (nonatomic, strong) UIColor                *rippleColor;
@property (nonatomic, strong) UIColor                *rippleBGColor;

@property (nonatomic, assign) BOOL                   isRippleOn;
@property (nonatomic, assign) BOOL                   isNextDismiss;

@property (nonatomic, assign) SEL                    methodName;
@property (nonatomic, strong) id                     superSender;

@end

@implementation WYTinderSwipeRippleButtton

#pragma mark - LifeCycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)commonInitWithImage:(UIImage *)image andFrame:(CGRect) frame{
    self.image = image;
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:self.gesture];
    
}

- (instancetype)initWithImage:(UIImage *)image
                    andFrame:(CGRect)frame
                   andTarget:(SEL)action
                       andID:(id)sender {
    self = [super initWithFrame:frame];
    
    if(self){
        [self commonInitWithImage:image andFrame:frame];
        self.methodName = action;
        self.superSender = sender;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame onCompletion:(WYTinderSwipeRippleButttonCompletion)completionBlock {
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self commonInitWithImage:image andFrame:frame];
        self.block = completionBlock;
    }
    
    return self;
}


#pragma mark - Public
- (void)loadImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)triggleAnimation {
    [self handleTap:nil withAction:NO];
}

- (void)setRippleEffectWithColor:(UIColor *)color {
    self.rippleColor = color;
}

- (void)setRippeEffectEnabled:(BOOL)enabled {
    self.isRippleOn = enabled;
}

- (void)setRippleEffectWithBGColor:(UIColor *)color {
    self.rippleBGColor = color;
}


#pragma mark - Private
- (void)handleTap:(id)sender {
    [self handleTap:sender withAction:YES];
}

- (void)handleTap:(id)sender withAction:(BOOL)isAction {
    if(self.isNextDismiss && !isAction) {
        self.isNextDismiss = NO;
        return;
    } else if(isAction) {
        self.isNextDismiss = YES;
    }
    
    if (self.isRippleOn) {
        UIColor *stroke = self.rippleColor ?: [UIColor colorWithWhite:0.8 alpha:0.8];
        UIColor *fillColor = self.rippleBGColor ?: [UIColor colorWithWhite:0.8 alpha:0.1];
        
        CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
        
        CGPoint shapePosition = self.containerView.center;
        
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = fillColor.CGColor;
        circleShape.opacity = 0;
        circleShape.strokeColor = stroke.CGColor;
        circleShape.lineWidth = 1;
        
        [self.containerView.layer addSublayer:circleShape];
        
        
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
    self.gesture.enabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if(isAction) {
            self.imageView.transform = CGAffineTransformMakeScale(1.15, 1.15);
        }
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.gesture.enabled = YES;
            if(isAction) {
                self.imageView.transform = CGAffineTransformMakeScale(1, 1);
            }
        }completion:^(BOOL finished) {
            if(isAction && [self.superSender respondsToSelector:self.methodName]){
                [self.superSender performSelectorOnMainThread:self.methodName withObject:nil waitUntilDone:NO];
            }
            
            if(_block && isAction) {
                BOOL success= YES;
                _block(success);
            }
        }];
        
    }];
}


#pragma mark - Getter
- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:self.image];
        _imageView.frame = self.bounds;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.layer.borderWidth = 3;
        _imageView.layer.cornerRadius = self.imageView.frame.size.height/2;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}


@end
