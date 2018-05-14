//
//  WPGAchieveAwardView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：每日任务限时活动领取动画页面
//

#import <UIKit/UIKit.h>

@class WPGAchieveAwardView,AVAudioPlayer,LOTAnimationView;

@protocol WPGAchieveAwardViewDelegate <NSObject>

/**
 * 关闭页面事件处理
 */
- (void)closeTheView:(WPGAchieveAwardView *)achieveAwardView;

@end

@interface WPGAchieveAwardView : UIView

@property (nonatomic, strong) UIImageView *awardView;
@property (nonatomic, strong) UIImageView *coinImageView;
@property (nonatomic, strong) UIImageView *expImageView;
@property (nonatomic, strong) UILabel *coinUnitLabel;
@property (nonatomic, strong) UILabel *expUnitLabel;
@property (nonatomic, strong) UILabel *coinValueLabel;
@property (nonatomic, strong) UILabel *expValueLabel;
@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;
@property (nonatomic, weak) id<WPGAchieveAwardViewDelegate> delegate;
@property (nonatomic, strong) LOTAnimationView *animationViewA;

/**
 * 加载数据
 * @coin:金币 @exp:经验值
 */
- (void)achieveAwardWithCoin:(NSInteger)coin exp:(NSInteger)exp;

@end
