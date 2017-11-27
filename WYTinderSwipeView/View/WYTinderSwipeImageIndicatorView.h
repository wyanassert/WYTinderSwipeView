//
//  DragImageIndicatorView.h
//  Neon
//
//  Created by wyan assert on 2017/11/15.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYTinderSwipeImageIndicatorView : UIView

- (instancetype)initWithTotalAmount:(NSUInteger)totalAmount;

@property (nonatomic, assign, readonly ) NSUInteger         totalAmount;
@property (nonatomic, assign, readwrite) NSUInteger         currentIndex;

@end
