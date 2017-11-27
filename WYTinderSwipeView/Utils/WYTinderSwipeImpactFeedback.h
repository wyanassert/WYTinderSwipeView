//
//  WYTinderSwipeImpactFeedback.h
//  Masonry
//
//  Created by wyan assert on 2017/11/27.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WTSImpactFeedbackType) {
    WTSImpactFeedbackTypeLight,
    WTSImpactFeedbackTypeMedium,
    WTSImpactFeedbackTypeHeavy
};

@interface WYTinderSwipeImpactFeedback : NSObject

+ (void)prepareForImpactFeedback:(WTSImpactFeedbackType)type;

@end
