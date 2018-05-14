//
//  WPGBrageRequest.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/28.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGBrageRequest.h"
#import "APIManager.h"

@implementation WPGBrageRequest

+ (NSURLSessionDataTask *)requestGetBadgeWithAchieveId:(NSString *)achieveId
                                               Success:(void (^)(id responseObj))successCallback
                                                  fail:(void (^)(NSError *error))failCallback
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params cl_setObject:achieveId forKey:@"achvId"];
    
    return [OauthHttpRequest requestGet:@"/users/achv.json" parameters:params success:^(id responseObject) {
        successCallback?successCallback(responseObject):nil;
        
    } failure:^(NSError *error) {
        failCallback?failCallback(error):nil;
    }];
}

@end
