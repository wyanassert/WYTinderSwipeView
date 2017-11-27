//
//  DraggableUserInfoView.m
//  Neon
//
//  Created by wyan assert on 2017/11/14.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//

#import "WYTinderSwipeDraggableDisplayView.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"

#import "WYTinderSwipeImageIndicatorView.h"
#import "WYTinderSwipeImpactFeedback.h"

@interface WYTinderSwipeDraggableDisplayView()

@property (nonatomic, strong) NSArray<NSString *>               *displayImageStr;
@property (nonatomic, assign) NSUInteger                        currentImageIndex;

@property (nonatomic, strong) UIImageView                       *imageView;
@property (nonatomic, strong) UIView                            *leftTapView;
@property (nonatomic, strong) UIView                            *rightTapView;
@property (nonatomic, strong) WYTinderSwipeImageIndicatorView   *indicatorView;

@end

@implementation WYTinderSwipeDraggableDisplayView

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame info:(WYTinderSwipeDisplayViewModel *)displayViewModel {
    if(self = [super initWithFrame:frame]) {
        _displayViewModel = displayViewModel;
        _displayImageStr = displayViewModel.imageArray;
        [self configView];
        [self loadData];
    }
    return self;
}


#pragma mark - Private
- (void)configView {
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self);
        make.top.equalTo(self).mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    [self addSubview:self.leftTapView];
    [self.leftTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    [self addSubview:self.rightTapView];
    [self.rightTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
    }];
}

- (void)loadData {
    if(self.displayImageStr.count) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.displayImageStr.firstObject] placeholderImage:[UIImage imageNamed:@"image_wts_cover_placehodler"]];
    }
}


#pragma mark - Action
- (void)leftTapAction {
    if(self.currentImageIndex > 0) {
        self.currentImageIndex --;
        self.indicatorView.currentIndex = self.currentImageIndex;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.displayImageStr[self.currentImageIndex]] placeholderImage:[UIImage imageNamed:@"image_wts_cover_placehodler"]];
        [WYTinderSwipeImpactFeedback prepareForImpactFeedback:WTSImpactFeedbackTypeLight];
    } else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didClickLeftSideAndWaitToShake)]) {
            [self.delegate didClickLeftSideAndWaitToShake];
        }
    }
}

- (void)rightTapAction {
    if(self.currentImageIndex < self.displayImageStr.count - 1) {
        self.currentImageIndex ++;
        self.indicatorView.currentIndex = self.currentImageIndex;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.displayImageStr[self.currentImageIndex]] placeholderImage:[UIImage imageNamed:@"image_wts_cover_placehodler"]];
        [WYTinderSwipeImpactFeedback prepareForImpactFeedback:WTSImpactFeedbackTypeLight];
    } else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didClickRightSideAndWaitToShake)]) {
            [self.delegate didClickRightSideAndWaitToShake];
        }
    }
}


#pragma mark - Getter
- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 3;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIView *)leftTapView {
    if(!_leftTapView) {
        _leftTapView = [UIView new];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapAction)];
        [_leftTapView addGestureRecognizer:tapGesture];
    }
    return _leftTapView;
}

- (UIView *)rightTapView {
    if(!_rightTapView) {
        _rightTapView = [UIView new];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapAction)];
        [_rightTapView addGestureRecognizer:tapGesture];
    }
    return _rightTapView;
}

- (WYTinderSwipeImageIndicatorView *)indicatorView {
    if(!_indicatorView) {
        _indicatorView = [[WYTinderSwipeImageIndicatorView alloc] initWithTotalAmount:self.displayImageStr.count];
    }
    return _indicatorView;
}

@end
