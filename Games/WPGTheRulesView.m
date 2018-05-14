//
//  WPGTheRulesView.m
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/25.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGTheRulesView.h"


#define ProportionWidth [UIScreen mainScreen].bounds.size.width/375
@interface WPGTheRulesView ()

@end



@implementation WPGTheRulesView

+ (instancetype)checkInViewWitWPGTheRulesViewWithwebStr:(NSString *)webStr{
    
    WPGTheRulesView *checkInView = [[WPGTheRulesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    checkInView.webStr = webStr;
    
    [checkInView.webview loadHTMLString:webStr baseURL:nil];
    
    return checkInView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self addSubview:self.backview];
    
    [self.backview addSubview:self.windowView];
    
    [self.windowView addSubview:self.webview];
    
    [self.windowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backview.mas_centerX);
        make.centerY.mas_equalTo(self.backview.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(295);
    }];
    
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.right.bottom.mas_equalTo(-20);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self czh_showView];
}


- (UIView *)backview{
    if (!_backview) {
        _backview = [[UIView alloc] initWithFrame:self.bounds];
        _backview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(czh_hideView)];
        [_backview addGestureRecognizer:tap];
    }
    return _backview;
}

- (UIImageView *)windowView{
    if (!_windowView) {
        _windowView = [[UIImageView alloc] init];
        _windowView.userInteractionEnabled = YES;
        _windowView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        _windowView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
        _windowView.layer.cornerRadius = 10.f;
        UITapGestureRecognizer *windowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowTap)];
        [_windowView addGestureRecognizer:windowTap];
    }
    return _windowView;
}

- (UIWebView *)webview{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _webview;
}
- (void)windowTap{
    
}


//打开弹窗
- (void)czh_showView {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.backview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _windowView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);;
    } completion:nil];
}

//关闭弹窗
- (void)czh_hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backview.backgroundColor = [UIColor clearColor];
        _windowView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}






@end
