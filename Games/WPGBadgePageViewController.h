//
//  WPGBadgePageViewController.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：奖章页面
//

#import "BaseViewController.h"
#import <Lottie/Lottie.h>

@class WPGAchieveMentListModel;

@interface WPGBadgePageViewController : BaseViewController

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *returnImageView;
@property (nonatomic, strong) UIView *returnView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) LOTAnimationView *animationView;
@property (nonatomic, strong) UIImageView *achieveImageView;
@property (nonatomic, strong) UILabel *achieveBtnLabel;
@property (nonatomic, strong) WPGAchieveMentListModel *model;
@property (nonatomic, assign) BOOL isMine;

- (void)initWithData:(WPGAchieveMentListModel *)achieveModel isMine:(BOOL)isMine;

@end
