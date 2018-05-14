//
//  WPGGameCollectionViewCell.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/12.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：游戏cell模块
//

#import <UIKit/UIKit.h>
#import "WPGGamePageModel.h"

@interface WPGGameCollectionViewCell : UICollectionViewCell

// 背景图片
@property (nonatomic, strong) UIImageView *backgroundImageview;
// 熟练度
@property (nonatomic, strong) UIImageView *levelImageView;
// 下部透明View
@property (nonatomic, strong) UIImageView *alphaImageview;
// 标题
@property (nonatomic, strong) UILabel *nameTitleLabel;
// 玩的人数
@property (nonatomic, strong) UILabel *playerCountLabel;
// 摆放类型 type:1-一排有一个cell 2-一排有两个cell
@property (nonatomic, assign) NSInteger type;

/**
 * 添加游戏cell数据
 */
- (void)cellWithData:(WPGGamePageGames *)gameModel;

@end
