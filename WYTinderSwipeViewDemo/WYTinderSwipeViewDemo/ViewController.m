//
//  ViewController.m
//  WYTinderSwipeViewDemo
//
//  Created by wyan assert on 2017/11/27.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "ViewController.h"
#import "WYTinderSwipeView.h"
#import "Masonry.h"

@interface ViewController () <WYTinderSwipeViewDelegate>

@property (nonatomic, strong) WYTinderSwipeView         *tinderSwipeView;
@property (nonatomic, strong) UIButton                  *checkButton;
@property (nonatomic, strong) UIButton                  *xButton;
@property (nonatomic, strong) UIButton                  *restoreButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tinderSwipeView];
    UIEdgeInsets insets = UIEdgeInsetsMake(80, 20, 150, 20);
    [self.tinderSwipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(insets);
    }];
    [self.tinderSwipeView startLoadData];
    [self.tinderSwipeView loadDisplayAvatar:[self randonImageArray]];
    
    [self.view addSubview:self.xButton];
    [self.xButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tinderSwipeView);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.width.height.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.checkButton];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tinderSwipeView);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.width.height.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.restoreButton];
    [self.restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tinderSwipeView);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.width.height.mas_equalTo(80);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (BOOL)loadMoreDataInsideSwipeViewWithCompletion:(WTSDraggableViewLoadMoreBlock)block {
    static NSInteger loadTime = 3;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(loadTime < 0) {
            if(block) {
                block(nil);
            }
            return ;
        }
        NSMutableArray <WYTinderSwipeDisplayViewModel *> *array = [NSMutableArray array];
        NSUInteger n = 3;
        while (n--) {
            WYTinderSwipeDisplayViewModel *model = [[WYTinderSwipeDisplayViewModel alloc] init];
            NSMutableArray<NSString *> *imageArray = [NSMutableArray array];
            NSUInteger imageCount = arc4random() % 4 + 1;
            while (imageCount--) {
                [imageArray addObject:[self randonImageArray]];
            }
            model.title = [NSString stringWithFormat:@"index %lu && image %lu", (unsigned long)n, (unsigned long)imageCount];
            model.imageArray = [imageArray copy];
            [array addObject:model];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(block) {
                block(array);
            }
        });
    });
    
    return loadTime -- >= 0;
}


#pragma mark - Private
- (NSString *)randonImageArray {
    NSArray *totalArray = @[@"http://www.sinaimg.cn/dy/slidenews/1_img/2017_47/88490_1527982_273169.jpg",
                            @"http://www.sinaimg.cn/dy/slidenews/1_img/2017_47/88490_1527981_671955.jpg",
                            @"http://www.sinaimg.cn/dy/slidenews/1_img/2017_47/88490_1527983_765382.jpg",
                            @"http://pic23.nipic.com/20120919/10612249_113052533161_2.png",
                            @"http://pic.58pic.com/58pic/16/58/28/80M58PICTcs_1024.jpg",
                            @"http://imgsrc.baidu.com/baike/pic/item/8d158aeecb3a7f452df534b6.jpg",
                            @"http://pic33.photophoto.cn/20141117/0005018343228376_b.jpg",
                            @"http://pic.666pic.com/thumbs/2754144/42825695/api_thumb_450.jpg",
                            @"http://pic.666pic.com/thumbs/1003369/15769179/api_thumb_450.jpg",
                            ];
    static NSUInteger index = 0;
    return totalArray[index++%totalArray.count];
}


#pragma mark - Action
- (void)swipeLeft {
    [self.tinderSwipeView swipeToLeft];
}

- (void)swipeRight {
    [self.tinderSwipeView swipeToRight];
}

- (void)cardRestore {
    [self.tinderSwipeView cardRestore];
}


#pragma mark - Getter
- (WYTinderSwipeView *)tinderSwipeView {
    if(!_tinderSwipeView) {
        _tinderSwipeView = [[WYTinderSwipeView alloc] init];
        _tinderSwipeView.delegate = self;
    }
    return _tinderSwipeView;
}

- (UIButton *)xButton {
    if(!_xButton) {
        _xButton = [[UIButton alloc] init];
        [_xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
        [_xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xButton;
}

- (UIButton *)checkButton {
    if(!_checkButton) {
        _checkButton = [[UIButton alloc] init];
        [_checkButton setImage:[UIImage imageNamed:@"yesButton"] forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

- (UIButton *)restoreButton {
    if(!_restoreButton) {
        _restoreButton = [[UIButton alloc] init];
        [_restoreButton setImage:[UIImage imageNamed:@"restoreImage"] forState:UIControlStateNormal];
        [_restoreButton addTarget:self action:@selector(cardRestore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restoreButton;
}

@end
