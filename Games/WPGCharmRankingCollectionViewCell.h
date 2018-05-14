//
//  WPGCharmRankingCollectionViewCell.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/15.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：魅力排行榜cell页
//

#import <UIKit/UIKit.h>
#import "WPGGamePageModel.h"

@interface WPGCharmRankingCollectionViewCell : UICollectionViewCell

// 背景图
@property (nonatomic, strong) UIImageView *coverImageView;
// 奖杯图
@property (nonatomic, strong) UIImageView *badgeImageView;
// 名称
@property (nonatomic, strong) UILabel *nameLabel;
// 魅力值
@property (nonatomic, strong) UILabel *charmLabel;
// 透明渐变层
@property (nonatomic, strong) UIView *fadeAlphaView;

/**
 * 填入魅力排行榜数据
 * @rankNum:游戏排名（从1开始）
 */
- (void)cellWithData:(WPGCharmRankSubModel *)rankModel RankNum:(NSInteger)rankNum;

@end
