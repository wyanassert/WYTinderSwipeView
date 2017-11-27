//
//  DraggableUserInfoView.h
//  Neon
//
//  Created by wyan assert on 2017/11/14.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//

#import "WYTinderSwipeDraggableView.h"
#import "WYTinderSwipeDisplayViewModel.h"

@protocol WYTinderSwipeDraggableDisplayViewDelegate <WYTinderSwipeDraggableViewDelegate>

- (void)didClickLeftSideAndWaitToShake;
- (void)didClickRightSideAndWaitToShake;

@end

@interface WYTinderSwipeDraggableDisplayView : WYTinderSwipeDraggableView

@property (nonatomic, strong) WYTinderSwipeDisplayViewModel          *displayViewModel;
@property (atomic   , weak  ) id<WYTinderSwipeDraggableDisplayViewDelegate>     delegate;

- (instancetype)initWithFrame:(CGRect)frame info:(WYTinderSwipeDisplayViewModel *)displayViewModel;

@end
