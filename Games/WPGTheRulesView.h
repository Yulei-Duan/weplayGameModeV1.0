//
//  WPGTheRulesView.h
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/25.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPGTheRulesView : UIView


@property (nonatomic, strong) UIView *backview;//背景灰色view

@property (nonatomic, strong) UIWebView *webview;//

@property (nonatomic, strong) UIImageView *windowView;//弹窗view

@property (nonatomic, strong) NSString *webStr;//


+ (instancetype)checkInViewWitWPGTheRulesViewWithwebStr:(NSString *)webStr;

@end
