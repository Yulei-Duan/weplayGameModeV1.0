//
//  NSTimer+WPGBlockSupport.h
//  WePlayGame
//
//  Created by leviduan on 2018/5/10.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (WPGBlockSupport)

+ (NSTimer *)wpg_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)(void))block
                                        repeats:(BOOL)repeats;

@end
