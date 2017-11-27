//
//  WYTinderSwipeDraggableView.m
//  Neon
//
//  Created by wyan assert on 2017/11/14.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//

#define ACTION_MARGIN               100
#define SCALE_STRENGTH              4
#define SCALE_MAX                   0.93
#define ROTATION_MAX                1
#define ROTATION_STRENGTH           320
#define ROTATION_ANGLE              M_PI/8
#define DismissAnimationInterval    0.2

#import "WYTinderSwipeDraggableView.h"

@interface WYTinderSwipeDraggableView()

@property (nonatomic, assign) CGFloat xFromCenter;
@property (nonatomic, assign) CGFloat yFromCenter;

@end


@implementation WYTinderSwipeDraggableView

@synthesize delegate;
@synthesize panGestureRecognizer;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        [self addGestureRecognizer:panGestureRecognizer];
        self.originalPoint = self.center;
    }
    return self;
}

- (void)setupView {
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

- (void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    self.xFromCenter = [gestureRecognizer translationInView:self].x;
    self.yFromCenter = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(self.xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            CGFloat scale = MAX(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            self.center = CGPointMake(self.originalPoint.x + self.xFromCenter, self.originalPoint.y + self.yFromCenter);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        default:
            break;
    }
}

- (void)afterSwipeAction {
    if (self.xFromCenter > ACTION_MARGIN) {
        [self rightAction];
        self.xFromCenter = 0;
    } else if (self.xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
        self.xFromCenter = 0;
    } else {
        [UIView animateWithDuration:DismissAnimationInterval
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)rightAction {
    CGPoint finishPoint = CGPointMake(500, 2*self.yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:DismissAnimationInterval
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    [delegate cardSwipedRight:self];
}

- (void)leftAction {
    CGPoint finishPoint = CGPointMake(-500, 2*self.yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:DismissAnimationInterval
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    [delegate cardSwipedLeft:self];
}

- (void)rightClickAction {
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:DismissAnimationInterval
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    [delegate cardSwipedRight:self];
}

- (void)leftClickAction {
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:DismissAnimationInterval
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    [delegate cardSwipedLeft:self];
}

@end
