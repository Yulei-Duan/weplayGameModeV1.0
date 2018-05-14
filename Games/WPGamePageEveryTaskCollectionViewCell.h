//
//  WPGamePageEveryTaskCollectionViewCell.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/16.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：限时活动以及每日任务页面 cell页面
//

#import <UIKit/UIKit.h>
#import "WPGGamePageModel.h"

@class WPGamePageEveryTaskCollectionViewCell;

@protocol WPGamePageEveryTaskCollectionViewCellDelegate <NSObject>

/**
 * 点击“领取”任务事件的处理
 */
- (void)receiveTheTask:(WPGamePageEveryTaskCollectionViewCell *)collectionViewCell andTaskModel:(WPGameTaskModel *)model;

@end

@interface WPGamePageEveryTaskCollectionViewCell : UICollectionViewCell

// 背景
@property (nonatomic, strong) UIImageView *backgroundImageView;
// 头像
@property (nonatomic, strong) UIImageView *avatarImageview;
// 名称
@property (nonatomic, strong) UILabel *nameLabel;
// 领取按钮
@property (nonatomic, strong) UIButton *receiveBtn;
// 金钱图标
@property (nonatomic, strong) UIImageView *moneyIconImageView;
// 经验图标
@property (nonatomic, strong) UIImageView *expIconImageView;
// 金钱数
@property (nonatomic, strong) UILabel *moneyLabel;
// 经验值
@property (nonatomic, strong) UILabel *expLabel;
// 单位
@property (nonatomic, strong) UILabel *unitLabel;
// 进度值
@property (nonatomic, strong) UILabel *progressLabel;
// 竖线
@property (nonatomic, strong) UIView *verticalLine;
// 横线
@property (nonatomic, strong) UIView *horizontalLine;
// 进度条
@property (nonatomic, strong) UIView *progressbar_topView;
// 底部进度条
@property (nonatomic, strong) UIView *progressbar_bottomView;
// 颜色进度条
@property (nonatomic, strong) UIImageView *progressbar_midView;
// 蒙版层
@property (nonatomic, strong) UIView *maskLayerView;
// model
@property (nonatomic, strong) WPGameTaskModel *model;
// 代理
@property (nonatomic, weak) id<WPGamePageEveryTaskCollectionViewCellDelegate> delegate;

/**
 * 添加任务以及活动的数据类型
 */
- (void)cellWithData:(WPGameTaskModel *)model;

@end
