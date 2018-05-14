//
//  WPGPersonLevelView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/24.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：人物等级升级动画页面
//

#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>

@class WPGPersonLevelView;

@protocol WPGPersonLevelViewDelegate <NSObject>

/**
 * 关闭页面事件处理
 */
- (void)closeLevelView:(WPGPersonLevelView *)levelView;

@end

@interface WPGPersonLevelView : UIView

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *levelImageView;
@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, weak) id <WPGPersonLevelViewDelegate> delegate;
@property (nonatomic, strong) LOTAnimationView *animationView;

/**
 * 加载等级数据
 */
- (void)setLevel:(NSString *)level;

@end
