//
//  WPGSubGameRankPage.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/24.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：游戏排行榜控制器（非总排行榜）
//

#import "BaseViewController.h"

@interface WPGSubGameRankPage : BaseViewController

/**
 * 填入游戏排行榜数据
 */
- (instancetype)initWithGameId:(NSString *)gameId;

@end
