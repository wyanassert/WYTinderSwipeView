//
//  WYTinderSwipeView.h
//  Neon
//
//  Created by wyan assert on 2017/11/14.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WYTinderSwipeDraggableDisplayView.h"

@class WYTinderSwipeDisplayViewModel;

typedef void(^WTSDraggableViewLoadMoreBlock)(NSArray<WYTinderSwipeDisplayViewModel *> *array);

@protocol WYTinderSwipeViewDelegate<NSObject>

- (BOOL)loadMoreDataInsideSwipeViewWithCompletion:(WTSDraggableViewLoadMoreBlock)block;

@end

@interface WYTinderSwipeView : UIView <WYTinderSwipeDraggableViewDelegate, WYTinderSwipeDraggableDisplayViewDelegate>

@property (nonatomic, assign) id<WYTinderSwipeViewDelegate>         delegate;

- (void)startLoadData;
- (void)loadDisplayAvatar:(NSString *)imageStr;

- (void)swipeToLeft;
- (void)swipeToRight;
- (void)cardRestore;
@end
