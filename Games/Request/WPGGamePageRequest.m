//
//  WPGGamePageRequest.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/13.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGGamePageRequest.h"
#import "APIManager.h"

static NSString * const sReqGameHomeURLPath = @"/game/home.json";
static NSString * const sReqGameRankingURLPath = @"/game/ranking.json";
static NSString * const sReqCharmRankingURLPath = @"/game/charmRanking.json";
static NSString * const sReqTasksURLPath = @"/game/tasks.json";
static NSString * const sReqGetTasksURLPath = @"/game/taskGet.json";
static NSString * const sReqnewTaskURLPath = @"/notice/newTask.json";

@implementation WPGGamePageRequest

+ (NSURLSessionDataTask *)GameHomeRequestSuccess:(void (^)(id responseObj))successCallback
                                            fail:(void (^)(NSError *error))failCallback
{
    //NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    //[params cl_setObject:@"lists" forKey:@"action"];
    
    return [OauthHttpRequest requestPost:sReqGameHomeURLPath parameters:nil cacheCallback:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } success:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } failure:^(NSError *error) {
        
        failCallback ? failCallback(error) : nil;
    }];
}

+ (NSURLSessionDataTask *)GameRankRequestSuccess:(void (^)(id responseObj))successCallback
                                            fail:(void (^)(NSError *error))failCallback
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params cl_setObject:@"0" forKey:@"type"];
    
    return [OauthHttpRequest requestGet:sReqGameRankingURLPath parameters:params cacheCallback:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } success:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } failure:^(NSError *error) {
        
        failCallback ? failCallback(error) : nil;
    }];
}

+ (NSURLSessionDataTask *)GameRankRequestGameId:(NSString *)gameId
                                        Success:(void (^)(id responseObj))successCallback
                                           fail:(void (^)(NSError *error))failCallback
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params cl_setObject:@"1" forKey:@"type"];
    [params cl_setObject:gameId forKey:@"gameId"];
    
    return [OauthHttpRequest requestGet:sReqGameRankingURLPath parameters:params cacheCallback:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } success:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } failure:^(NSError *error) {
        
        failCallback ? failCallback(error) : nil;
    }];
}

+ (NSURLSessionDataTask *)CharmRankRequestSuccess:(void (^)(id responseObj))successCallback
                                             fail:(void (^)(NSError *error))failCallback
{
    return [OauthHttpRequest requestPost:sReqCharmRankingURLPath parameters:nil cacheCallback:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } success:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } failure:^(NSError *error) {
        
        failCallback ? failCallback(error) : nil;
    }];
}

+ (NSURLSessionDataTask *)gameTaskRequestType:(NSInteger)type
                                      Success:(void (^)(id responseObj))successCallback
                                         fail:(void (^)(NSError *error))failCallback
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params cl_setObject:[NSString stringWithFormat:@"%@", @(type)] forKey:@"type"];
    
    return [OauthHttpRequest requestGet:sReqTasksURLPath parameters:params cacheCallback:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } success:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } failure:^(NSError *error) {
        
        failCallback ? failCallback(error) : nil;
    }];
}

+ (NSURLSessionDataTask *)gameTaskWithTaskId:(NSString *)taskId
                                     Success:(void (^)(id responseObj))successCallback
                                        fail:(void (^)(NSError *error))failCallback
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params cl_setObject:taskId forKey:@"id"];
    
    return [OauthHttpRequest requestPost:sReqGetTasksURLPath parameters:params success:^(id responseObject) {
        successCallback?successCallback(responseObject):nil;
        
    } failure:^(NSError *error) {
        failCallback?failCallback(error):nil;
    }];
}

+ (NSURLSessionDataTask *)starGamesWithgGameId:(NSString *)gameId
                                       Success:(void (^)(id responseObj))successCallback
                                          fail:(void (^)(NSError *error))failCallback
{
    NSString *urlStr = @"/game/start.json";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (!IS_NS_STRING_EMPTY(gameId)) {    
        [param cl_setObject:gameId forKey:@"gameId"];
    }
    
//    return [OauthHttpRequest requestGet:urlStr parameters:param cacheCallback:^(id responseObj) {
//        successCallback? successCallback(responseObj) : nil;
//    } success:^(id resonseObj) {
//        successCallback? successCallback(resonseObj) : nil;
//    } failure:^(NSError *error) {
//        failCallback? failCallback(error) : nil;
//    }];
    
    return [OauthHttpRequest requestGet:urlStr parameters:param success:^(id resonseObj) {
        successCallback(resonseObj);
        
    } failure:^(NSError *error) {
        failCallback(error);
    }];
}

+ (NSURLSessionDataTask *)gameShareInfoWithGameId:(NSString *)gameId
                                          Success:(void (^)(id responseObj))successCallback
                                             fail:(void (^)(NSError *error))failCallback
{
    NSString *urlStr = @"/game/shareInfo.json";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params cl_setObject:gameId forKey:@"gameId"];
    
    return [OauthHttpRequest requestPost:urlStr parameters:params success:^(id resonseObj) {
        successCallback(resonseObj);
        
    } failure:^(NSError *error) {
        failCallback(error);
    }];
}

+ (NSURLSessionDataTask *)gameRequestRedViewSuccess:(void (^)(id responseObj))successCallback
                                               fail:(void (^)(NSError *error))failCallback
{
    return [OauthHttpRequest requestGet:sReqnewTaskURLPath parameters:nil success:^(id resonseObj) {
        successCallback(resonseObj);
        
    } failure:^(NSError *error) {
        failCallback(error);
    }];
}

+ (NSURLSessionDataTask *)completeGetGiftWithGameId:(NSString *)gameId
                                            Success:(void (^)(id responseObj))successCallback
                                               fail:(void (^)(NSError *error))failCallback
{
    NSString *urlStr = @"/game/completeGetGift.json";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params cl_setObject:gameId forKey:@"gameId"];
    
    return [OauthHttpRequest requestPost:urlStr parameters:params success:^(id resonseObj) {
        successCallback(resonseObj);
        
    } failure:^(NSError *error) {
        failCallback(error);
    }];
}


+ (NSURLSessionDataTask *)gameShareInfoCallbackRequestSuccess:(void (^)(id responseObj))successCallback
                                                         fail:(void (^)(NSError *error))failCallback
{
    NSString *urlStr = @"/game/shareInfoCallback.json";

    return [OauthHttpRequest requestGet:urlStr parameters:nil success:^(id resonseObj) {
        successCallback(resonseObj);
        
    } failure:^(NSError *error) {
        failCallback(error);
    }];
}



@end
