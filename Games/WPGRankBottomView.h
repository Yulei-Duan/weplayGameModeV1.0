//
//  WPGRankBottomView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/14.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：排行榜底部的我的信息个人栏控件
//

#import <UIKit/UIKit.h>
#import "WPGGamePageModel.h"

@interface WPGRankBottomView : UIView

// 游戏排名
@property (nonatomic, strong) UILabel *rankLabel;
// 头像
@property (nonatomic, strong) UIImageView *avatarImageView;
// 段位
@property (nonatomic, strong) UIImageView *levelImageView;
// 名称
@property (nonatomic, strong) UILabel *nameLabel;
// 前三名魅力榜和游戏榜单的奖杯图
@property (nonatomic, strong) UIImageView *photoFrameView;
// 分数
@property (nonatomic, strong) UILabel *scoreLabel;
// 单位
@property (nonatomic, strong) UILabel *unitLabel;
// 魅力奖杯图
@property (nonatomic, strong) UIImageView *charmImageView;

/**
 * 填入游戏排行榜数据
 */
- (void)bottomViewWithSubGameData:(WPGGamePageMyRank *)rankModel;

/**
 * 填入游戏排行总榜数据
 */
- (void)bottomViewWithData:(WPGGamePageMyRank *)rankModel;

/**
 * 填入魅力排行榜数据
 */
- (void)bottomViewWithCharmData:(WPGCharmMyRank *)rankModel;

/**
 * 再次调整魅力排行榜Frame布局
 */
- (void)justCharmFrame;

@end
