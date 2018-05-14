//
//  WPGGamePageModel.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/13.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGGamePageModel.h"

@implementation WPGGamePageModel

+ (NSDictionary *)objectClassInArray{
    return @{@"ranking" : [WPGGamePageRanking class], @"games" : [WPGGamePageGames class]};
}

@end

@implementation WPGGamePageRanking

@end

@implementation WPGGamePageGames

@end

@implementation WPGGamePageMyRank

@end

@implementation WPGGamePageRankModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WPGGamePageRanking class]};
}

@end

@implementation WPGCharmRankModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WPGCharmRankSubModel class]};
}

@end

@implementation WPGCharmMyRank

@end

@implementation WPGCharmRankSubModel

@end

@implementation WPGameTaskModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"taskId":@"id",
             @"money":@"cons"
             };
}

@end

@implementation WPGWinslevel

@end

@implementation WPGGetRedNewTaskModel

@end
