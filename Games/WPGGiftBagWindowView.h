//
//  WPGGiftBagWindowView.h
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPGGetPrizeAnimationView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface WPGGiftBagWindowView : UIView

@property (nonatomic, strong) UIImageView *backImage;//高斯背景

@property (nonatomic, strong) UIImageView *titleImage;//标题

@property (nonatomic, assign) NSInteger diamind;//金币数量

@property (nonatomic, strong) UILabel *diaminLabel;//金币

@property (nonatomic, strong) WPGGetPrizeAnimationView *getPrizeView;//动画view

@property (nonatomic, strong) AVAudioPlayer *rewardsPlayer;//领取成功音效


+ (instancetype)checkInViewWithDynamicPopViewWithDiamindStr:(NSInteger)diamindStr;

@end
