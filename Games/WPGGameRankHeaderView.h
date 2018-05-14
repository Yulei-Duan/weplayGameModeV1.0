//
//  WPGGameRankHeaderView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/14.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：游戏排名头部View
//

#import <UIKit/UIKit.h>
#import "WPGGamePageModel.h"

@class WPGGameRankHeaderView;

@protocol WPGGameRankHeaderViewDelegate <NSObject>

/**
 * 点击用户头像事件
 */
- (void)openAvatarProfile:(WPGGameRankHeaderView *)headerView withUid:(NSString *)uid;

@end

@interface WPGGameRankHeaderView : UIView

@property (nonatomic, weak) id <WPGGameRankHeaderViewDelegate> delegate;

/**
 * 添加游戏排行榜数据
 */
- (void)addDataWithArray:(NSArray<WPGGamePageRanking *> *)rankArray;

@end
