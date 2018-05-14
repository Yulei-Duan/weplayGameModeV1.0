//
//  WPGPersonalCenterCollectionViewCell.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：个人中心Cell页面
//

#import <UIKit/UIKit.h>
#import "WPGProfileCenterModel.h"

@interface WPGPersonalCenterCollectionViewCell : UICollectionViewCell

// 背景图
@property (nonatomic ,strong) UIImageView *backgroundImageView;
// 徽章图
@property (nonatomic ,strong) UIImageView *coverImageView;
// 未领取标志
@property (nonatomic ,strong) UIImageView *newImageView;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/**
 * 添加个人中心的数据类型
 */
- (void)cellWithData:(WPGAchieveMentListModel *)achievementModel;

@end
