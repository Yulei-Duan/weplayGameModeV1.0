//
//  WPGEveryTaskAndActivity.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/12.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：首页列表的每日任务和显示活动模块
//

#import <UIKit/UIKit.h>

@class WPGEveryTaskAndActivity;

@protocol WPGEveryTaskAndActivityDelegate <NSObject>

/**
 * 点击每日人物事件处理
 */
- (void)openEveryTaskPage:(WPGEveryTaskAndActivity *)everyTaskView;

/**
 * 点击限时活动事件处理
 */
- (void)openActivityPage:(WPGEveryTaskAndActivity *)everyTaskView;

@end

@interface WPGEveryTaskAndActivity : UIView

@property (nonatomic, strong) UIView *redViewA;
@property (nonatomic, strong) UIView *redViewB;
@property (nonatomic, weak) id<WPGEveryTaskAndActivityDelegate> delegate;

@end
