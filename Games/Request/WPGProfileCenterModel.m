//
//  WPGProfileCenterModel.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGProfileCenterModel.h"

@implementation WPGProfileCenterModel

@end

@implementation WPGUserinfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"exp":@"nowLevelExp"
             };
}

@end

@implementation WPGUserAchievementModel

+ (NSDictionary *)objectClassInArray{
    return @{@"achv" : [WPGAchieveMentListModel class],
             @"game" : [WPGameListModel class]};
}

@end

@implementation WPGAchieveMentListModel

@end

@implementation WPGameListModel

@end
