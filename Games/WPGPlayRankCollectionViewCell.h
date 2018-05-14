//
//  WPGPlayRankCollectionViewCell.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/14.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：总排行榜cell页
//

#import <UIKit/UIKit.h>
#import "WPGGamePageModel.h"

@class WPGPlayRankCollectionViewCell;

@protocol WPGPlayRankCollectionViewCellDelegate <NSObject>

/**
 * 排行榜内，点击游戏cell头像事件
 */
- (void)openAvatarProfile:(WPGPlayRankCollectionViewCell *)cell WithUid:(NSString *)uid;

@end

@interface WPGPlayRankCollectionViewCell : UICollectionViewCell

// 游戏排名
@property (nonatomic, strong) UILabel *rankLabel;
// 头像
@property (nonatomic, strong) UIImageView *avatarImageView;
// 名称
@property (nonatomic, strong) UILabel *nameLabel;
// 游戏段位
@property (nonatomic, strong) UIImageView *gameRankImageView;
// 分数
@property (nonatomic, strong) UILabel *scoreLabel;
// 单位
@property (nonatomic, strong) UILabel *unitLabel;
// 下划线
@property (nonatomic, strong) UIView *lineView;
// isSubGame:True-总排行榜 False-游戏排行榜
@property (nonatomic, assign) BOOL isSubGame;
// 游戏排行榜前三名奖杯形状的图片
@property (nonatomic, strong) UIImageView *badgeImageView;
// 用户id
@property (nonatomic, copy) NSString *uid;
// 代理
@property (nonatomic, weak) id <WPGPlayRankCollectionViewCellDelegate> delegate;

/**
 * 对第一个Cell进行特别处理
 */
- (void)firstCell;

/**
 * 对最后一个Cell进行特别处理
 */
- (void)lastCell;

/**
 * 对其他Cell进行特别处理
 */
- (void)midCell;

/**
 * 使cell赋予空数据
 */
- (void)noDataCell;

/**
 * 使cell赋予正常数据model
 */
- (void)cellWithData:(WPGGamePageRanking *)rankModel RankNum:(NSInteger)rankNum;

@end
