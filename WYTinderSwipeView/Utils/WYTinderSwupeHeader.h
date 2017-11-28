//
//  WYTinderSwupeHeader.h
//  Pods
//
//  Created by wyan assert on 2017/11/27.
//

#ifndef WYTinderSwupeHeader_h
#define WYTinderSwupeHeader_h

#define WTS_Scale_Min 0.9
#define WTS_Scale_Normal 1.0

#define WTS_ACTION_MARGIN               60
#define WTS_SCALE_STRENGTH              4
#define WTS_SCALE_MAX                   0.93
#define WTS_ROTATION_MAX                1
#define WTS_ROTATION_STRENGTH           320
#define WTS_ROTATION_ANGLE              M_PI/8

#define DismissAnimationInterval        0.2

#define WTS_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define WTS_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define WTS_SCREENAPPLY(x, y) CGSizeMake(WTS_SCREEN_WIDTH / 375.0 * (x), WTS_SCREEN_HEIGHT / 667.0 * (y))
#define WTS_SCREENAPPLYSPACE(x) (WTS_SCREEN_WIDTH / 375.0 * (x))
#define WTS_SCREENAPPLYHEIGHT(x) (WTS_SCREEN_HEIGHT / 667.0 * (x))

#define WTS_UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define WTS_UIColorFromRGB(r,g,b)               WTS_UIColorFromRGBA(r,g,b,1.0)

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

#endif /* WYTinderSwupeHeader_h */
