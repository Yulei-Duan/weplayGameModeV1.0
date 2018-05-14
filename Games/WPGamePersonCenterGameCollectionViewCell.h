//
//  WPGamePersonCenterGameCollectionViewCell.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：个人中心游戏模块cell
//

#import <UIKit/UIKit.h>
#import "WPGProfileCenterModel.h"

@interface WPGamePersonCenterGameCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *gameImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *gameNumLabel;
@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) UIImageView *levelImageView;

- (void)loadDataWithModel:(WPGameListModel *)gameModel;

@end
