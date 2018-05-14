//
//  WPGGamePageHeaderImageView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/12.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：游戏列表上方的排行榜模块
//

#import <UIKit/UIKit.h>
#import "WPGGamePageModel.h"

@class WPGGamePageHeaderImageView;

@protocol WPGGamePageHeaderImageViewDelegate <NSObject>

/**
 * 点击首页排行榜页面事件处理
 */
- (void)openRankPage:(WPGGamePageHeaderImageView *)gamePageHeaderImageView;

@end

@interface WPGGamePageHeaderImageView : UIImageView

@property (nonatomic, weak) id<WPGGamePageHeaderImageViewDelegate> delegate;

/**
 * 排行榜模块添加数据
 */
- (void)addDataWithArray:(NSArray<WPGGamePageRanking *> *)rankArray;

@end
