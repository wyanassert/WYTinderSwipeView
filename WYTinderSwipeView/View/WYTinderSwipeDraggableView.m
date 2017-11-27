//
//  DraggableView.m
//  RKSwipeCards
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#define ACTION_MARGIN               100
#define SCALE_STRENGTH              4
#define SCALE_MAX                   .93
#define ROTATION_MAX                1
#define ROTATION_STRENGTH           320
#define ROTATION_ANGLE              M_PI/8
#define DismissAnimationInterval    0.2

#import "WYTinderSwipeDraggableView.h"

@implementation WYTinderSwipeDraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

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
    xFromCenter = [gestureRecognizer translationInView:self].x;
    yFromCenter = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            CGFloat scale = MAX(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
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
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
        xFromCenter = 0;
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
        xFromCenter = 0;
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
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:DismissAnimationInterval
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    [delegate cardSwipedRight:self];
}

- (void)leftAction {
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
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
