//
//  WPGGamePageRequest.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/13.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：游戏首页请求列表
//

#import <Foundation/Foundation.h>

@interface WPGGamePageRequest : NSObject

/**
 * 游戏首页网络请求接口
 */
+ (NSURLSessionDataTask *)GameHomeRequestSuccess:(void (^)(id responseObj))successCallback
                                            fail:(void (^)(NSError *error))failCallback;

/**
 * 游戏总排行榜接口
 */
+ (NSURLSessionDataTask *)GameRankRequestSuccess:(void (^)(id responseObj))successCallback
                                            fail:(void (^)(NSError *error))failCallback;

/**
 * 游戏排行榜接口
 */
+ (NSURLSessionDataTask *)GameRankRequestGameId:(NSString *)gameId
                                        Success:(void (^)(id responseObj))successCallback
                                           fail:(void (^)(NSError *error))failCallback;

/**
 * 魅力榜总排行榜接口
 */
+ (NSURLSessionDataTask *)CharmRankRequestSuccess:(void (^)(id responseObj))successCallback
                                            fail:(void (^)(NSError *error))failCallback;

/**
 * 任务列表接口
 */
+ (NSURLSessionDataTask *)gameTaskRequestType:(NSInteger)type
                                       Success:(void (^)(id responseObj))successCallback
                                          fail:(void (^)(NSError *error))failCallback;

/**
 * 任务领取接口
 */
+ (NSURLSessionDataTask *)gameTaskWithTaskId:(NSString *)taskId
                                     Success:(void (^)(id responseObj))successCallback
                                        fail:(void (^)(NSError *error))failCallback;

/**
 * 开始游戏详情接囗
 */
+ (NSURLSessionDataTask *)starGamesWithgGameId:(NSString *)gameId
                                     Success:(void (^)(id responseObj))successCallback
                                        fail:(void (^)(NSError *error))failCallback;


/**
 * 邀请好友接囗
 */
+ (NSURLSessionDataTask *)gameShareInfoWithGameId:(NSString *)gameId
                                          Success:(void (^)(id responseObj))successCallback
                                          fail:(void (^)(NSError *error))failCallback;

/**
 * 请求红点接口
 */
+ (NSURLSessionDataTask *)gameRequestRedViewSuccess:(void (^)(id responseObj))successCallback
                                               fail:(void (^)(NSError *error))failCallback;

/**
 * 完成任务领取礼物接囗
 */
+ (NSURLSessionDataTask *)completeGetGiftWithGameId:(NSString *)gameId
                                       Success:(void (^)(id responseObj))successCallback
                                          fail:(void (^)(NSError *error))failCallback;


/**
 * 分享成功回调接口
 */
+ (NSURLSessionDataTask *)gameShareInfoCallbackRequestSuccess:(void (^)(id responseObj))successCallback
                                            fail:(void (^)(NSError *error))failCallback;

@end
