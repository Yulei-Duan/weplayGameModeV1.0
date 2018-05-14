//
//  WPGRuleView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：排行榜的右上角规则页面
//

#import <UIKit/UIKit.h>

@class WPGRuleView;

@protocol WPGRuleViewDelegate <NSObject>

/**
 * 关闭“排行榜规则界面”的事件处理
 */
- (void)closeTheRuleview:(WPGRuleView *)ruleView;

@end

@interface WPGRuleView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *ruleBackgroundView;

@property (nonatomic, weak) id<WPGRuleViewDelegate> delegate;

/**
 *  游戏总榜的规则页面
 */
- (void)addTotalFrameView;

/**
 *  游戏榜（非总榜）的规则页面
 */
- (void)addsubGameFrameView;

@end
