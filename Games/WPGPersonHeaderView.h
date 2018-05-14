//
//  WPGPersonHeaderView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：个人中心头部模块
//

#import <UIKit/UIKit.h>
#import "IDSGenderLeviNamedView.h"
#import "WPGProfileCenterModel.h"

@class WPGPersonHeaderView;

@protocol WPGPersonHeaderDelegate <NSObject>

/**
 * 点击个人中心头部左上角图标的事件处理
 */
- (void)clickLeftBtnAction:(WPGPersonHeaderView *)personHeaderView;

/**
 * 点击个人中心头部右上角图标的事件处理
 */
- (void)clickRightBtnAction:(WPGPersonHeaderView *)personHeaderView;

@end

@interface WPGPersonHeaderView : UIView

// 背景图
@property (nonatomic, strong) UIImageView *backgroundImageView;
// 天空A
@property (nonatomic, strong) UIImageView *starAImageView;
// 天空B
@property (nonatomic, strong) UIImageView *starBImageView;
// 返回图片
@property (nonatomic, strong) UIImageView *gobackImageView;
// 返回触摸View
@property (nonatomic, strong) UIView *gobackView;
// 右上角按钮图
@property (nonatomic, strong) UIImageView *rightBtnImageView;
// 右上角按钮触摸View
@property (nonatomic, strong) UIView *rightBtnView;
// 头像
@property (nonatomic, strong) UIImageView *avatarImageView;
// 性别
@property (nonatomic, strong) IDSGenderLeviNamedView *genderNamedView;
// 游戏等级图
@property (nonatomic, strong) UIImageView *gameLevelImageView;
// 名称
@property (nonatomic, strong) UILabel *nameLabel;
// 地址
@property (nonatomic, strong) UILabel *locationLabel;
// 进度条
@property (nonatomic, strong) UIView *progressbar_topView;
// 底部进度条
@property (nonatomic, strong) UIView *progressbar_bottomView;
// 等级
@property (nonatomic, strong) UILabel *levelLabel;
// 等级昵称
@property (nonatomic, strong) UILabel *levelNameLabel;
// 等级图片
@property (nonatomic, strong) UIImageView *levelImageView;
@property (nonatomic, strong) UIImageView *expImageView;
@property (nonatomic, strong) UIImageView *liuxingView;
@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, assign) BOOL minePersonCenter;
@property (nonatomic, strong) NSTimer *upqueryNoticeTimer;
@property (nonatomic, weak) id<WPGPersonHeaderDelegate> delegate;

/**
 * 添加个人中心头部的数据类型
 */
- (void)addDataWithModel:(WPGUserinfoModel *)dataModel;

/**
 * 初始化时，传入个人中心参数
 * @minePersonCenter: True 代表是我的个人中心 False 代表他人中心
 */
- (instancetype)initWithFrame:(CGRect)frame WithMineCenter:(BOOL)minePersonCenter;

/**
 * 重新调整个人中心的UI布局
 */
- (void)adjustMineViewFrame;

/**
 * 星空动画播放方法(用到了UIview动画，所以需要每次加载都要执行一次)
 */
- (void)makeAnimitionVoid;

@end
