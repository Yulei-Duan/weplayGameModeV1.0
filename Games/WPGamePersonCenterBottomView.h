//
//  WPGamePersonCenterBottomView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：个人中心底部模块
//

#import <UIKit/UIKit.h>

@class WPGamePersonCenterBottomView;

@protocol WPGamePersonCenterBottomViewDelegate<NSObject>

/**
 * 点击“增加好友”的事件处理
 */
- (void)addFriendAction:(WPGamePersonCenterBottomView *)personCenterView;

/**
 * 点击“聊天”的事件处理
 */
- (void)chatAction:(WPGamePersonCenterBottomView *)personCenterView;

@end

@interface WPGamePersonCenterBottomView : UIView

@property (nonatomic, strong) UIImageView *friendImageView;
@property (nonatomic, strong) UIImageView *chatImageView;
@property (nonatomic, strong) UILabel *friendLabel;
@property (nonatomic, strong) UILabel *chatLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, weak) id<WPGamePersonCenterBottomViewDelegate> delegate;

/**
 * 加载数据
 * @friendStatus: 0-不是我朋友 1-是我朋友 2-状态等待验证
 */
- (void)dataWithFriendStatus:(NSInteger)friendStatus;

@end
