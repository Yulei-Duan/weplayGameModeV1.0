//
//  WPGSayHiPersonCellView.h
//  WePlayGame
//
//  Created by leviduan on 2018/5/3.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content:SayHi页面的聊天栏视图 FrameSize : (screen_width,65)
//

#import <UIKit/UIKit.h>

@class WPGChatRecommendModel;

@interface WPGSayHiPersonCellView : UIView

// 加载聊天视图数据
- (void)viewLoadDataWithModel:(WPGChatRecommendModel *)chatmodel;

@end
