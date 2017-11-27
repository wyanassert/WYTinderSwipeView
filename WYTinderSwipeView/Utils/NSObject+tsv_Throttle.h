//
//  NSObject+tsv_Throttle.h
//  Masonry
//
//  Created by wyan assert on 2017/11/27.
//

#import <Foundation/Foundation.h>

@interface NSObject (tsv_Throttle)

- (void)tsv_performSelector:(SEL)aSelector withThrottle:(NSTimeInterval)inteval;

@end
