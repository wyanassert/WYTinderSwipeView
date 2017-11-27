//
//  WYTinderSwipeView.h
//  Neon
//
//  Created by wyan assert on 2017/11/14.
//  Copyright © 2017年 NeonPopular. All rights reserved.
//


#import "WYTinderSwipeView.h"

#import "WYTinderSwupeHeader.h"
#import "Masonry.h"
#import "SDWebImageManager.h"
#import "NSObject+tsv_Throttle.h"

#import "WYTinderSwipeDisplayViewModel.h"
#import "WYTinderSwipeDraggableDisplayView.h"
#import "WYTinderSwipeRippleButtton.h"
#import "WYTinderSwipeImpactFeedback.h"


#define kLoadMoreThreshold 4
#define kLoadMaxRestoreNumber 50

@interface WYTinderSwipeView()

@property (retain,nonatomic ) NSMutableArray<WYTinderSwipeDisplayViewModel *>       *dataArray;
@property (retain,nonatomic ) NSMutableArray<WYTinderSwipeDraggableDisplayView *>   *allCards;
@property (nonatomic, strong) NSMutableArray<WYTinderSwipeDraggableDisplayView *>   *loadedCards;
@property (nonatomic, strong) NSMutableArray<WYTinderSwipeDraggableDisplayView *>   *saveCards;
@property (nonatomic, assign) NSInteger                                             cardsLoadedIndex;
@property (nonatomic, strong) UIView                                                *containerView;
@property (   atomic, assign) BOOL                                                  isLoadingMore;
@property (nonatomic, strong) WYTinderSwipeRippleButtton                            *loadMoreButton;
@property (nonatomic, strong) NSTimer                                               *timer;

@end

@implementation WYTinderSwipeView

static const int MAX_BUFFER_SIZE = 2;

- (instancetype)init {
    if(self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self configView];
}


#pragma mark - Public
- (void)startLoadData {
    [self loadMoreData];
}

- (void)loadDisplayAvatar:(NSString *)imageStr {
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageStr]
                                                options:0
                                               progress:nil
                                              completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                  if(image && !error) {
                                                      [_loadMoreButton loadImage:image];
                                                  }
                                              }];
}

- (void)swipeToLeft {
    [self innerSwipeLeft];
}

- (void)swipeToRight {
    [self innerSwipeRight];
}

- (void)cardRestore {
    [self tsv_performSelector:@selector(innerCardRestore) withThrottle:0.5];
}


#pragma mark - Private
- (void)configView {
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.containerView addSubview:self.loadMoreButton];
    [self.loadMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.width.height.mas_equalTo(WTS_SCREENAPPLYSPACE(100));
    }];
}

- (WYTinderSwipeDraggableDisplayView *)createDraggableViewWithDataAtIndex:(NSInteger)index {
    if(index >= self.dataArray.count) {
        return [WYTinderSwipeDraggableDisplayView new];
    }
    WYTinderSwipeDraggableDisplayView *draggableView = [[WYTinderSwipeDraggableDisplayView alloc]initWithFrame:self.bounds info:self.dataArray[index]];
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

- (void)innerSwipeRight {
    WYTinderSwipeDraggableView *dragView = [self.loadedCards firstObject];
    [dragView rightClickAction];
}

- (void)innerSwipeLeft {
    WYTinderSwipeDraggableView *dragView = [self.loadedCards firstObject];
    [dragView leftClickAction];
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


#pragma mark - Getter
- (NSMutableArray<WYTinderSwipeDisplayViewModel *> *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<WYTinderSwipeDraggableDisplayView *> *)allCards {
    if(!_allCards) {
        _allCards = [NSMutableArray array];
    }
    return _allCards;
}

- (NSMutableArray<WYTinderSwipeDraggableDisplayView *> *)loadedCards {
    if(!_loadedCards) {
        _loadedCards = [NSMutableArray array];
    }
    return _loadedCards;
}

- (WYTinderSwipeRippleButtton *)loadMoreButton {
    if(!_loadMoreButton) {
        _loadMoreButton = [[WYTinderSwipeRippleButtton alloc]
                           initWithImage:[UIImage imageNamed:@"image_wts_avatar_placehodler"]
                           andFrame:CGRectMake(0, 0, WTS_SCREENAPPLYSPACE(100), WTS_SCREENAPPLYSPACE(100))
                           andTarget:@selector(loadMoreData)
                           andID:self];
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
