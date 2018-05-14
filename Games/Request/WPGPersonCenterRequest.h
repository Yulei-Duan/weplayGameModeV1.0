//
//  WPGPersonCenterRequest.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：用户中心网络请求
//

#import <Foundation/Foundation.h>

@interface WPGPersonCenterRequest : NSObject

/**
 * 查看用户信息
 */
+ (NSURLSessionDataTask *)personCenterRequestWithUid:(NSString *)uid
                                     Success:(void (^)(id responseObj))successCallback
                                        fail:(void (^)(NSError *error))failCallback;

/**
 * 用户成就以及用户玩过的游戏列表
 */
+ (NSURLSessionDataTask *)personCenterAchieveArrayRequestWithUid:(NSString *)uid
                                             Success:(void (^)(id responseObj))successCallback
                                                fail:(void (^)(NSError *error))failCallback;

/**
 * 请求添加好友
 */
+ (NSURLSessionDataTask *)requestAddFriendWithUid:(NSString *)uid
                                          Success:(void (^)(id responseObj))successCallback
                                             fail:(void (^)(NSError *error))failCallback;

@end
