//
//  DragImageIndicatorView.m
//  Neon
//
//  Created by wyan assert on 2017/11/15.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//

#import "WYTinderSwipeImageIndicatorView.h"
#import "Masonry.h"

#define kLightColor [UIColor whiteColor]
#define kDarkColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

@interface WYTinderSwipeImageIndicatorView()

@property (nonatomic, strong) NSMutableArray<UIView *>         *subviewArray;

@end

@implementation WYTinderSwipeImageIndicatorView

- (instancetype)initWithTotalAmount:(NSUInteger)totalAmount {
    if(self = [super init]) {
        _totalAmount = totalAmount;
        for(NSUInteger i = 0; i < totalAmount; i++) {
            [self.subviewArray addObject:[self createIndicator]];
        }
        [self.subviewArray.firstObject setBackgroundColor:kLightColor];
        
        [self configView];
    }
    return self;
}


#pragma mark - Private
- (void)configView {
    UIView *lastView = nil;
    for (UIView *indicator in self.subviewArray) {
        [self addSubview:indicator];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(6);
            make.centerY.equalTo(self);
            if(!lastView) {
                make.left.mas_equalTo(self).offset(4);
            } else {
                make.left.mas_equalTo(lastView.mas_right).offset(8);
                make.width.equalTo(lastView.mas_width);
            }
            if(indicator == self.subviewArray.lastObject) {
                make.right.mas_equalTo(self).offset(-4);
            }
        }];
        lastView = indicator;
    }
}

- (UIView *)createIndicator {
    UIView *indicator = [UIView new];
    
    indicator.backgroundColor = kDarkColor;
    indicator.layer.masksToBounds = YES;
    indicator.layer.cornerRadius = 4;
    
    return indicator;
}

#pragma mark - Setter
- (void)setCurrentIndex:(NSUInteger)currentIndex {
    if(currentIndex >= self.subviewArray.count || _currentIndex == currentIndex) {
        return ;
    }
    self.subviewArray[_currentIndex].backgroundColor = kDarkColor;
    _currentIndex = currentIndex;
    self.subviewArray[_currentIndex].backgroundColor = kLightColor;
}


#pragma mark - Getter
- (NSMutableArray<UIView *> *)subviewArray {
    if(!_subviewArray) {
        _subviewArray = [NSMutableArray array];
    }
    return _subviewArray;
}

@end
