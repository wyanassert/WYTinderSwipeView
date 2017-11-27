//
//  DraggableViewBackground.m
//  RKSwipeCards
//
//  Created by Richard Kim on 8/23/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "WYTinderSwipeView.h"

#import "Masonry.h"
#import "SDWebImageManager.h"

#import "WYTinderSwipeDisplayViewModel.h"
#import "WYTinderSwipeDraggableDisplayView.h"
#import "WYTinderSwipeRippleButtton.h"
#import "WYTinderSwipeImpactFeedback.h"
#import "NSObject+tsv_Throttle.h"
#import "WYTinderSwupeHeader.h"

#define kLoadMoreThreshold 4
#define kLoadMaxRestoreNumber 50

@interface WYTinderSwipeView()

@property (retain,nonatomic ) NSMutableArray<WYTinderSwipeDisplayViewModel *>       *dataArray;
@property (retain,nonatomic ) NSMutableArray<WYTinderSwipeDraggableDisplayView *>   *allCards;
@property (nonatomic, strong) NSMutableArray<WYTinderSwipeDraggableDisplayView *>   *loadedCards;
@property (nonatomic, strong) NSMutableArray<WYTinderSwipeDraggableDisplayView *>   *saveCards;
@property (nonatomic, assign) NSInteger                                             cardsLoadedIndex;
@property (nonatomic, strong) UIView                                                *containerView;
@property (nonatomic, strong) UIButton                                              *checkButton;
@property (nonatomic, strong) UIButton                                              *xButton;
@property (nonatomic, strong) UIButton                                              *restoreButton;
@property (   atomic, assign) BOOL                                                  isLoadingMore;
@property (nonatomic, strong) WYTinderSwipeRippleButtton                            *loadMoreButton;
@property (nonatomic, strong) NSTimer                                               *timer;

@end

@implementation WYTinderSwipeView

static const int MAX_BUFFER_SIZE = 2;
static const float CARD_HEIGHT = 480;
static const float CARD_WIDTH = 340;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self configView];
        self.dataArray = [NSMutableArray array];
        self.loadedCards = [[NSMutableArray alloc] init];
        self.allCards = [[NSMutableArray alloc] init];
        self.cardsLoadedIndex = 0;
    }
    return self;
}


#pragma mark - Public
- (void)startLoadData {
    [self loadMoreData];
}

- (void)cardRestore {
    [self tsv_performSelector:@selector(innerCardRestore) withThrottle:0.5];
}


#pragma mark - Private
- (void)configView {
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(80);
        make.width.mas_equalTo(CARD_WIDTH);
        make.height.mas_equalTo(CARD_HEIGHT);
        make.centerX.equalTo(self);
    }];
    
    [self.containerView addSubview:self.loadMoreButton];
    [self.loadMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.width.height.mas_equalTo(WTS_SCREENAPPLYHEIGHT(100));
    }];
    
    [self addSubview:self.xButton];
    [self.xButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(WTS_SCREENAPPLYHEIGHT(16));
        make.left.equalTo(self.containerView);
        make.width.height.mas_equalTo(WTS_SCREENAPPLYHEIGHT(60));
    }];
    
    [self addSubview:self.checkButton];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(WTS_SCREENAPPLYHEIGHT(16));
        make.right.equalTo(self.containerView);
        make.width.height.mas_equalTo(WTS_SCREENAPPLYHEIGHT(60));
    }];
    
    [self addSubview:self.restoreButton];
    [self.restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(WTS_SCREENAPPLYHEIGHT(16));
        make.centerX.equalTo(self.containerView);
        make.width.height.mas_equalTo(WTS_SCREENAPPLYHEIGHT(60));
    }];
}

- (WYTinderSwipeDraggableDisplayView *)createDraggableViewWithDataAtIndex:(NSInteger)index {
    if(index >= self.dataArray.count) {
        return [WYTinderSwipeDraggableDisplayView new];
    }
    WYTinderSwipeDraggableDisplayView *draggableView = [[WYTinderSwipeDraggableDisplayView alloc]initWithFrame:CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT) info:self.dataArray[index]];
    draggableView.delegate = self;
    return draggableView;
}

- (void)loadMoreData {
    if(self.isLoadingMore) {
        return;
    }
    self.isLoadingMore = YES;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(loadMoreDataInsideSwipeViewWithCompletion:)]) {
        __weak typeof(self)weakSelf = self;
        BOOL isMore = [self.delegate loadMoreDataInsideSwipeViewWithCompletion:^(NSArray<WYTinderSwipeDisplayViewModel *> *array) {
            __strong typeof(weakSelf)self = weakSelf;
            self.isLoadingMore = NO;
            if(array.count) {
                [self invalidateTimer];
                [self.loadMoreButton setRippeEffectEnabled:NO];
                NSUInteger oldDataCount = self.dataArray.count;
                [self.dataArray addObjectsFromArray:array];
                
                NSInteger numLoadedCardsCap = MIN(MAX_BUFFER_SIZE, [self.dataArray count]);
                
                NSMutableArray<WYTinderSwipeDraggableDisplayView *> *tmpCardsArray = [NSMutableArray array];
                for(NSUInteger i = oldDataCount; i < self.dataArray.count; i++) {
                    WYTinderSwipeDraggableDisplayView* newCard = [self createDraggableViewWithDataAtIndex:i];
                    [tmpCardsArray addObject:newCard];
                    
                    if(i < numLoadedCardsCap) {
                        [self.loadedCards addObject:newCard];
                    }
                }
                [self.allCards addObjectsFromArray:tmpCardsArray];
                
                for (NSUInteger i = oldDataCount; i < [self.loadedCards count]; i++) {
                    if (i > 0) {
                        [self.containerView insertSubview:[self.loadedCards objectAtIndex:i] belowSubview:[self.loadedCards objectAtIndex:i-1]];
                    } else {
                        [self.containerView addSubview:[self.loadedCards objectAtIndex:i]];
                    }
                    self.cardsLoadedIndex++;
                }
            }
        }];
        if(isMore) {
            
        } else {
            self.isLoadingMore = NO;
        }
    } else {
        self.isLoadingMore = NO;
    }
}

- (void)innerCardRestore {
    WYTinderSwipeDraggableDisplayView *userInfoView = self.saveCards.lastObject;
    if(userInfoView) {
        [self.saveCards removeLastObject];
        [self addDataOnTop:userInfoView];
    }
}

- (void)addDataOnTop:(WYTinderSwipeDraggableDisplayView *)view {
    [self.containerView addSubview:view];
    self.cardsLoadedIndex++;
    [view afterSwipeAction];
    
    if(view.displayViewModel) {
        [self.dataArray insertObject:view.displayViewModel atIndex:0];
    }
    [self.loadedCards insertObject:view atIndex:0];
    [self.allCards insertObject:view atIndex:0];
    
    WYTinderSwipeDraggableDisplayView *waitToDeleteView = self.loadedCards.lastObject;
    if(waitToDeleteView != view && self.loadedCards.count > MAX_BUFFER_SIZE) {
        [waitToDeleteView removeFromSuperview];
        self.cardsLoadedIndex--;
        [self.loadedCards removeLastObject];
    }
}

- (void)removeFirstData {
    WYTinderSwipeDraggableDisplayView *uselessView = self.loadedCards.firstObject;
    if(uselessView) {
        if([self.allCards containsObject:uselessView]) {
            [self.allCards removeObject:uselessView];
            self.cardsLoadedIndex--;
        }
        [self.loadedCards removeObject:uselessView];
        [self.dataArray removeObject:uselessView.displayViewModel];
        
        if(self.saveCards.count > 0 && self.saveCards.count >= kLoadMaxRestoreNumber) {
            [self.saveCards removeObjectAtIndex:0];
        }
        [self.saveCards addObject:uselessView];
    }
    
    if(!self.isLoadingMore && self.allCards.count < kLoadMoreThreshold) {
        [self loadMoreData];
    }
    if(self.allCards.count == 0) {
        [self.loadMoreButton setRippeEffectEnabled:YES];
        [self handleLoadButtonAnimation];
        [self invalidateTimer];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(handleLoadButtonAnimation) userInfo:nil repeats:YES];
    }
}

- (void)handleLoadButtonAnimation {
    [self.loadMoreButton triggleAnimation];
}

- (void)invalidateTimer {
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)shakeAnimation:(BOOL)isLeft {
    [WYTinderSwipeImpactFeedback prepareForImpactFeedback:WTSImpactFeedbackTypeMedium];
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CATransform3D transform = CATransform3DIdentity;
                         transform.m34 = - 1.0 / 500.0;
                         CGFloat shakeAngel = isLeft?-M_PI/25:M_PI/25;
                         transform = CATransform3DRotate(transform, shakeAngel, 0, 1, 0);
                         self.containerView.layer.transform = transform;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CATransform3D transform = CATransform3DIdentity;
                                              transform.m34 = - 1.0 / 500.0;
                                              transform = CATransform3DRotate(transform, 0, 0, 1, 0);
                                              self.containerView.layer.transform = transform;
                                          } completion:^(BOOL finished) {
                                              [WYTinderSwipeImpactFeedback prepareForImpactFeedback:WTSImpactFeedbackTypeLight];
                                          }];
                     }];
}


#pragma mark - DraggableViewDelegate
- (void)cardSwipedLeft:(UIView *)card {
    [self removeFirstData];
    if (self.cardsLoadedIndex < [self.allCards count] && self.cardsLoadedIndex < MAX_BUFFER_SIZE) {
        [self.loadedCards addObject:[self.allCards objectAtIndex:self.cardsLoadedIndex]];
        self.cardsLoadedIndex++;
        [self.containerView insertSubview:[self.loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[self.loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

- (void)cardSwipedRight:(UIView *)card {
    [self removeFirstData];
    if (self.cardsLoadedIndex < [self.allCards count]) {
        [self.loadedCards addObject:[self.allCards objectAtIndex:self.cardsLoadedIndex]];
        self.cardsLoadedIndex++;
        [self.containerView insertSubview:[self.loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[self.loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

- (void)didClickLeftSideAndWaitToShake {
    [self shakeAnimation:YES];
}

- (void)didClickRightSideAndWaitToShake {
    [self shakeAnimation:NO];
}


#pragma mark - Action
- (void)swipeRight {
    WYTinderSwipeDraggableView *dragView = [self.loadedCards firstObject];
    [dragView rightClickAction];
}

- (void)swipeLeft {
    WYTinderSwipeDraggableView *dragView = [self.loadedCards firstObject];
    [dragView leftClickAction];
}


#pragma mark - Getter
- (UIButton *)xButton {
    if(!_xButton) {
        _xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 485, 59, 59)];
        [_xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
        [_xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xButton;
}

- (UIButton *)checkButton {
    if(!_checkButton) {
        _checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
        [_checkButton setImage:[UIImage imageNamed:@"yesButton"] forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

- (UIButton *)restoreButton {
    if(!_restoreButton) {
        _restoreButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
        [_restoreButton setImage:[UIImage imageNamed:@"restoreImage"] forState:UIControlStateNormal];
        [_restoreButton addTarget:self action:@selector(cardRestore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restoreButton;
}

- (WYTinderSwipeRippleButtton *)loadMoreButton {
    if(!_loadMoreButton) {
        _loadMoreButton = [[WYTinderSwipeRippleButtton alloc] initWithImage:[UIImage imageNamed:@"neon_broadcast_avatar_placehodler"]
                                                        andFrame:CGRectMake((WTS_SCREEN_WIDTH - WTS_SCREENAPPLYHEIGHT(100)) / 2, (WTS_SCREEN_HEIGHT - WTS_SCREENAPPLYHEIGHT(100)) / 2, WTS_SCREENAPPLYHEIGHT(100), WTS_SCREENAPPLYHEIGHT(100))
                                                    andTarget:@selector(loadMoreData) andID:self];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:@""]
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                      if(image && !error) {
                                                          [_loadMoreButton loadImage:image];
                                                      }
                                                  }];
        [_loadMoreButton setRippleEffectWithColor:WTS_UIColorFromRGB(242, 144, 158)];
        [_loadMoreButton setRippleEffectWithBGColor:WTS_UIColorFromRGBA(242, 144, 158, 0.2)];
    }
    return _loadMoreButton;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (NSMutableArray<WYTinderSwipeDraggableDisplayView *> *)saveCards {
    if(!_saveCards) {
        _saveCards = [NSMutableArray array];
    }
    return _saveCards;
}

@end
