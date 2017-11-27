//
//  WYTinderSwipeImpactFeedback.m
//  Masonry
//
//  Created by wyan assert on 2017/11/27.
//

#import "WYTinderSwipeImpactFeedback.h"


@implementation WYTinderSwipeImpactFeedback

+ (void)prepareForImpactFeedback:(WTSImpactFeedbackType)type {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyle)type];
        [generator prepare];
        [generator impactOccurred];
    } else {
        
    }
}

@end
