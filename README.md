# WYTinderSwipeView
An Univerasl Swipe View Imitate Tinder

1. 导入`WYTinderSwipeView`

  1.1 Cocospods

  `pod 'WYTinderSwipeView'`

  1.2 Manual Import

  Drag `WYTinderSwipeView` directory and `Resource` directory into your project.

2. 添加引用

   `#import "WYTinderSwipeView.h"`

   `WYTinderSwipeView  *tinderSwipeView = [[WYTinderSwipeView alloc] init]; `

   `tinderSwipeView.delegate = self;`

   then layout With Masonry.

   Or you can init `WYTinderSwipeView` using `initWithFrame`.

3. load Data -- ccomplete `WYTinderSwipeViewDelegate`

  `- (BOOL)loadMoreDataInsideSwipeViewWithCompletion:(WTSDraggableViewLoadMoreBlock)block`

  fetch your data and then call `block` when loading data finished.

  return YES when dataSource exist more data. OtherWhile return No.

4. Run project in WYTinderSwipeViewDemo directory for using.

5. ![Demo](ScreenShoot/Demo.gif)
