//
//  WPGGameMatchingCell.h
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPGGameMatchingModel.h"

@interface WPGGameMatchingCell : UITableViewCell

//@property (nonatomic, strong) UIImageView *leftImage;//前三排名

@property (nonatomic, strong) UILabel *leftLabel;//排名

@property (nonatomic, strong) UIImageView *iconImage;//头像

@property (nonatomic, strong) UILabel *nameLabel;//名字

@property (nonatomic, strong) UILabel *scoreLabel;//分数

@property (nonatomic, strong) UIImageView *rightImage;//右箭头

@property (nonatomic, strong) MatchList *model;



@end
