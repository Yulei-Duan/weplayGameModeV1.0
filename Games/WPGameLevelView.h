//
//  WPGameLevelView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：段位升级或降级页面
//

#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>

@class WPGameLevelView;

@protocol WPGameLevelViewDelegate <NSObject>

/**
 * 关闭页面事件处理
 */
- (void)closeLevelView:(WPGameLevelView *)levelView;

@end

@interface WPGameLevelView : UIView

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *levelImageView;
@property (nonatomic, strong) UIImageView *taskBannerImageView;
@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL rankAdvancement;
@property (nonatomic, weak) id<WPGameLevelViewDelegate> delegate;
@property (nonatomic, strong) LOTAnimationView *animationView;

/**
 * 加载数据
 * @imageUrl: 大图URL @rankName: 段位等级名称  @isUp：True-段位上升 False-段位下降
 */
- (void)getlevelImageUrl:(NSString *)imageUrl rankName:(NSString *)rankName isUp:(BOOL)isup; 

@end
