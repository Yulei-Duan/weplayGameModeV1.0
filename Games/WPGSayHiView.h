//
//  WPGSayHiView.h
//  WePlayGame
//
//  Created by leviduan on 2018/5/3.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content:用户推荐页面
//

#import <UIKit/UIKit.h>

@class WPGChatRecommendModel,WPGSayHiView;

@protocol WPGSayHiViewDelegate <NSObject>

/**
 * 按钮的点击回调代理方法
 */
- (void)clickPlayButton:(WPGSayHiView *)sayHiView;

@end

@interface WPGSayHiView : UIView

@property (nonatomic, weak) id<WPGSayHiViewDelegate> delegate;

/**
 * 初始化参数 传递WPGChatRecommendModel类型数组.
 */
- (instancetype)initWithFrame:(CGRect)frame WithModel:(NSArray<WPGChatRecommendModel *> *)modelArray;

/**
 * 如果使用 -initWithframe 的初始化方法初始化实例，需要通过这个方法来传递数据.
 */
- (void)dataWithModelArray:(NSArray<WPGChatRecommendModel *> *)modelArray;

@end
