//
//  WYTinderSwipeDraggableView.h
//  Neon
//
//  Created by wyan assert on 2017/11/14.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYTinderSwipeDraggableViewDelegate <NSObject>

- (void)cardSwipedLeft:(UIView *)card;
- (void)cardSwipedRight:(UIView *)card;

@end

@interface WYTinderSwipeDraggableView : UIView

@property (weak) id <WYTinderSwipeDraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;

- (void)leftClickAction;
- (void)rightClickAction;
- (void)afterSwipeAction;

@end
