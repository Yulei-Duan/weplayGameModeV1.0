//
//  NSTimer+WPGBlockSupport.m
//  WePlayGame
//
//  Created by leviduan on 2018/5/10.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "NSTimer+WPGBlockSupport.h"

@implementation NSTimer (WPGBlockSupport)

+ (NSTimer *)wpg_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)(void))block
                                        repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(wpg_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)wpg_blockInvoke:(NSTimer *)timer
{
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
