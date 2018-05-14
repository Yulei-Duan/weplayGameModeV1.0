//
//  WPGBrageRequest.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/28.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPGBrageRequest : NSObject

/**
 * 用户领取成就
 */
+ (NSURLSessionDataTask *)requestGetBadgeWithAchieveId:(NSString *)achieveId
                                               Success:(void (^)(id responseObj))successCallback
                                                  fail:(void (^)(NSError *error))failCallback;

@end
