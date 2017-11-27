//
//  NSObject+tsv_Throttle.m
//  Masonry
//
//  Created by wyan assert on 2017/11/27.
//

#import "NSObject+tsv_Throttle.h"
#import <objc/runtime.h>
#import <objc/message.h>

static char WZThrottledSelectorKey;
static char WZThrottledSerialQueue;

@implementation NSObject (tsv_Throttle)

- (void)tsv_performSelector:(SEL)aSelector withThrottle:(NSTimeInterval)inteval {
    dispatch_async([self getSerialQueue], ^{
        NSMutableDictionary *blockedSelectors = [objc_getAssociatedObject(self, &WZThrottledSelectorKey) mutableCopy];
        
        if (!blockedSelectors) {
            blockedSelectors = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(self, &WZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        NSString *selectorName = NSStringFromSelector(aSelector);
        if (![blockedSelectors objectForKey:selectorName]) {
            [blockedSelectors setObject:selectorName forKey:selectorName];
            objc_setAssociatedObject(self, &WZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ((id (*)(id, SEL))objc_msgSend)(self, aSelector);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(inteval * NSEC_PER_SEC)), [self getSerialQueue], ^{
                    [self unlockSelector:selectorName];
                });
            });
        }
    });
}

#pragma mark - Private
- (void)unlockSelector:(NSString *)selectorName
{
    dispatch_async([self getSerialQueue], ^{
        NSMutableDictionary *blockedSelectors = [objc_getAssociatedObject(self, &WZThrottledSelectorKey) mutableCopy];
        
        if ([blockedSelectors objectForKey:selectorName]) {
            [blockedSelectors removeObjectForKey:selectorName];
        }
        
        objc_setAssociatedObject(self, &WZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    });
}

- (dispatch_queue_t)getSerialQueue
{
    dispatch_queue_t serialQueur = objc_getAssociatedObject(self, &WZThrottledSerialQueue);
    if (!serialQueur) {
        serialQueur = dispatch_queue_create("com.satanwoo.throttle", NULL);
        objc_setAssociatedObject(self, &WZThrottledSerialQueue, serialQueur, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return serialQueur;
}

@end
