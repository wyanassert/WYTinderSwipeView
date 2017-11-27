//
//  WYTinderSwupeHeader.h
//  Pods
//
//  Created by wyan assert on 2017/11/27.
//

#ifndef WYTinderSwupeHeader_h
#define WYTinderSwupeHeader_h

#define WTS_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define WTS_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define WTS_SCREENAPPLY(x, y) CGSizeMake(WTS_SCREEN_WIDTH / 375.0 * (x), WTS_SCREEN_HEIGHT / 667.0 * (y))
#define WTS_SCREENAPPLYSPACE(x) (WTS_SCREEN_WIDTH / 375.0 * (x))
#define WTS_SCREENAPPLYHEIGHT(x) (WTS_SCREEN_HEIGHT / 667.0 * (x))

#define WTS_UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define WTS_UIColorFromRGB(r,g,b)               WTS_UIColorFromRGBA(r,g,b,1.0)

#endif /* WYTinderSwupeHeader_h */
