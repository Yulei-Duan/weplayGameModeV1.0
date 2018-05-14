//
//  WPGPersonCenterRequest.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGPersonCenterRequest.h"
#import "APIManager.h"

static NSString * const sReqProfileURLPath = @"/users/profile.json";
static NSString * const sReqAchieveURLPath = @"/users/achvList.json";
static NSString * const sReqAddFriendURLPath = @"/friends/request.json";

@implementation WPGPersonCenterRequest

+ (NSURLSessionDataTask *)personCenterRequestWithUid:(NSString *)uid
                                             Success:(void (^)(id responseObj))successCallback
                                                fail:(void (^)(NSError *error))failCallback
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params cl_setObject:uid forKey:@"uid"];
    
    return [OauthHttpRequest requestGet:sReqProfileURLPath parameters:params success:^(id responseObject) {
        successCallback?successCallback(responseObject):nil;
        
    } failure:^(NSError *error) {
        failCallback?failCallback(error):nil;
    }];
    
    /*
    return [OauthHttpRequest requestGet:sReqProfileURLPath parameters:params cacheCallback:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } success:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } failure:^(NSError *error) {
        
        failCallback ? failCallback(error) : nil;
        
    }];
    
    */
}

+ (NSURLSessionDataTask *)personCenterAchieveArrayRequestWithUid:(NSString *)uid
                                                         Success:(void (^)(id responseObj))successCallback
                                                            fail:(void (^)(NSError *error))failCallback
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params cl_setObject:uid forKey:@"uid"];
    
    return [OauthHttpRequest requestGet:sReqAchieveURLPath parameters:params cacheCallback:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } success:^(id responseObject) {
        
        successCallback ? successCallback(responseObject) : nil;
        
    } failure:^(NSError *error) {
        
        failCallback ? failCallback(error) : nil;
        
    }];
}

+ (NSURLSessionDataTask *)requestAddFriendWithUid:(NSString *)uid
                                          Success:(void (^)(id responseObj))successCallback
                                             fail:(void (^)(NSError *error))failCallback
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params cl_setObject:uid forKey:@"fuid"];
    
    return [OauthHttpRequest requestPost:sReqAddFriendURLPath parameters:params success:^(id responseObject) {
        successCallback?successCallback(responseObject):nil;
        
    } failure:^(NSError *error) {
        failCallback?failCallback(error):nil;
    }];
}

@end
