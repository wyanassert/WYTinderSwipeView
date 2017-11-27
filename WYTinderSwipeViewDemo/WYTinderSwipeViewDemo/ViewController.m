//
//  ViewController.m
//  WYTinderSwipeViewDemo
//
//  Created by wyan assert on 2017/11/27.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "ViewController.h"
#import "WYTinderSwipeView.h"

@interface ViewController () <WYTinderSwipeViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WYTinderSwipeView *draggableBackground = [[WYTinderSwipeView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:draggableBackground];
    draggableBackground.delegate = self;
    [draggableBackground startLoadData];
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
                            @"http://pic33.photophoto.cn/20141117/0005018343228376_b.jpg"
                            ];
    return totalArray[arc4random()%totalArray.count];
}


@end
