//
//  WPGRuleView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGRuleView.h"

@implementation WPGRuleView 

- (void)dealloc
{
    IDSLOG(@"WPGRuleView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithUI];
    }
    return self;
}

- (void)initWithUI
{
    TRACK_SECOND_LEVEL_CLICK(@"ranking", @"ranking_list_rule", nil);
    [self addSubview:self.ruleBackgroundView];
    UITapGestureRecognizer *releaseGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseView)];
    releaseGesture.delegate = self;
    [self addGestureRecognizer:releaseGesture];
}

- (void)addTotalFrameView
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [ColorUtil cl_colorWithHexString:@"#000000" alpha:0.6];
    UILabel *titleLabelA = [[UILabel alloc] init];
    titleLabelA.frame = CGRectMake(31, 23, 0, 0);
    titleLabelA.text = @"段位规则";
    titleLabelA.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabelA.textColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    [titleLabelA sizeToFit];
    
    UIView *titleViewA = [[UIView alloc] init];
    titleViewA.frame = CGRectMake(24, 0, 3, 15);
    titleViewA.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    titleViewA.layer.cornerRadius = 1.5f;
    titleViewA.layer.masksToBounds = YES;
    titleViewA.centerY = titleLabelA.centerY;
    
    UILabel *contentA = [[UILabel alloc] init];
    contentA.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    contentA.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    contentA.numberOfLines = 0;
    contentA.text = @"共有六大段位：倔强青铜、不屈白银、荣耀黄金、尊贵铂金、永恒钻石、最强王者6个段位。除了最强王者段位外，其余段位均有3个小段，分别为III、II、I级别。";
    contentA.frame = CGRectMake(22, CGRectGetMaxY(titleLabelA.frame)+4, 236, 0);
    [contentA sizeToFit];
    
    UILabel *titleLabelB = [[UILabel alloc] init];
    titleLabelB.frame = CGRectMake(31, CGRectGetMaxY(contentA.frame)+17, 0, 0);
    titleLabelB.text = @"积分规则";
    titleLabelB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabelB.textColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    [titleLabelB sizeToFit];
    
    UIView *titleViewB = [[UIView alloc] init];
    titleViewB.frame = CGRectMake(24, 0, 3, 15);
    titleViewB.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    titleViewB.layer.cornerRadius = 1.5f;
    titleViewB.layer.masksToBounds = YES;
    titleViewB.centerY = titleLabelB.centerY;
    
    UILabel *contentB = [[UILabel alloc] init];
    contentB.text = @"总榜积分等于所有游戏的积分之和。";
    contentB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    contentB.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    contentB.numberOfLines = 0;
    contentB.frame = CGRectMake(22, CGRectGetMaxY(titleLabelB.frame)+4, 236, 0);
    [contentB sizeToFit];
    
    UILabel *contentC = [[UILabel alloc] init];
    contentC.text = @"加分情况：每胜一场加25分";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentC.text];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:NSMakeRange(0, [contentC.text length])];
    NSRange tmpRange = [[[attributedString string] lowercaseString] rangeOfString:@"加分"];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#7262FF"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:tmpRange];
    contentC.attributedText = attributedString;
    contentC.numberOfLines = 0;
    contentC.frame = CGRectMake(22, CGRectGetMaxY(contentB.frame)+4, 236, 0);
    [contentC sizeToFit];
    
    UILabel *contentE = [[UILabel alloc] init];
    contentE.text = @"减分情况：每输一场减20分 (即游戏PK失败)";
    
    NSMutableAttributedString *attributedStringB = [[NSMutableAttributedString alloc] initWithString:contentE.text];
    [attributedStringB setAttributes:@{NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:NSMakeRange(0, [contentE.text length])];
    NSRange tmpRangeB = NSMakeRange(0, 2);
    
    [attributedStringB addAttributes:@{NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#FF3D34"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:tmpRangeB];
    contentE.attributedText = attributedStringB;
    contentE.numberOfLines = 0;
    contentE.frame = CGRectMake(22, CGRectGetMaxY(contentC.frame)+4, 236, 0);
    [contentE sizeToFit];
    
    UILabel *titleLabelC = [[UILabel alloc] init];
    titleLabelC.frame = CGRectMake(31, CGRectGetMaxY(contentE.frame)+17, 0, 0);
    titleLabelC.text = @"魅力规则";
    titleLabelC.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabelC.textColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    [titleLabelC sizeToFit];
    
    UIView *titleViewC = [[UIView alloc] init];
    titleViewC.frame = CGRectMake(24, 0, 3, 15);
    titleViewC.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    titleViewC.layer.cornerRadius = 1.5f;
    titleViewC.layer.masksToBounds = YES;
    titleViewC.centerY = titleLabelC.centerY;
    
    UILabel *contentF = [[UILabel alloc] init];
    contentF.text = @"收到赠送的礼物，将增加你的魅力值。";
    contentF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    contentF.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    contentF.numberOfLines = 0;
    contentF.frame = CGRectMake(22, CGRectGetMaxY(titleLabelC.frame)+4, 236, 0);
    [contentF sizeToFit];
    
    [self.ruleBackgroundView addSubview:titleLabelA];
    [self.ruleBackgroundView addSubview:titleLabelB];
    [self.ruleBackgroundView addSubview:titleLabelC];
    
    [self.ruleBackgroundView addSubview:titleViewA];
    [self.ruleBackgroundView addSubview:titleViewB];
    [self.ruleBackgroundView addSubview:titleViewC];
    
    [self.ruleBackgroundView addSubview:contentA];
    [self.ruleBackgroundView addSubview:contentB];
    [self.ruleBackgroundView addSubview:contentC];
    [self.ruleBackgroundView addSubview:contentE];
    [self.ruleBackgroundView addSubview:contentF];
    
    self.ruleBackgroundView.frame = CGRectMake(0, 0, 280, 30+CGRectGetMaxY(contentF.frame));
    self.ruleBackgroundView.centerX = SCREEN_WIDTH / 2.0;
    self.ruleBackgroundView.centerY = self.frame.size.height / 2.0;
    self.ruleBackgroundView.tag = 1001;
    self.ruleBackgroundView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [self showView];
}

- (void)addsubGameFrameView
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [ColorUtil cl_colorWithHexString:@"#000000" alpha:0.6];
    
    UILabel *titleLabelB = [[UILabel alloc] init];
    titleLabelB.frame = CGRectMake(31, 23, 0, 0);
    titleLabelB.text = @"积分规则";
    titleLabelB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabelB.textColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    [titleLabelB sizeToFit];
    
    UIView *titleViewB = [[UIView alloc] init];
    titleViewB.frame = CGRectMake(24, 0, 3, 15);
    titleViewB.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    titleViewB.layer.cornerRadius = 1.5f;
    titleViewB.layer.masksToBounds = YES;
    titleViewB.centerY = titleLabelB.centerY;
    
    UILabel *contentB = [[UILabel alloc] init];
    contentB.text = @"总榜积分等于所有游戏的积分之和。";
    contentB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    contentB.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    contentB.numberOfLines = 0;
    contentB.frame = CGRectMake(22, CGRectGetMaxY(titleLabelB.frame)+4, 236, 0);
    [contentB sizeToFit];
    
    UILabel *contentC = [[UILabel alloc] init];
    contentC.text = @"加分情况：每胜一场加25分";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentC.text];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:NSMakeRange(0, [contentC.text length])];
    NSRange tmpRange = [[[attributedString string] lowercaseString] rangeOfString:@"加分"];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#7262FF"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:tmpRange];
    contentC.attributedText = attributedString;
    contentC.numberOfLines = 0;
    contentC.frame = CGRectMake(22, CGRectGetMaxY(titleLabelB.frame)+4, 236, 0);
    [contentC sizeToFit];
    
    UILabel *contentE = [[UILabel alloc] init];
    contentE.text = @"减分情况：每输一场减20分 (即游戏PK失败)";
    
    NSMutableAttributedString *attributedStringB = [[NSMutableAttributedString alloc] initWithString:contentE.text];
    [attributedStringB setAttributes:@{NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:NSMakeRange(0, [contentE.text length])];
    NSRange tmpRangeB = NSMakeRange(0, 2);
    
    [attributedStringB addAttributes:@{NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#FF3D34"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:tmpRangeB];
    contentE.attributedText = attributedStringB;
    contentE.numberOfLines = 0;
    contentE.frame = CGRectMake(22, CGRectGetMaxY(contentC.frame)+4, 236, 0);
    [contentE sizeToFit];
    
    [self.ruleBackgroundView addSubview:titleLabelB];
    //[self.ruleBackgroundView addSubview:contentB];
    [self.ruleBackgroundView addSubview:titleViewB];
    [self.ruleBackgroundView addSubview:contentC];
    [self.ruleBackgroundView addSubview:contentE];
    
    self.ruleBackgroundView.frame = CGRectMake(0, 0, 280, 30+CGRectGetMaxY(contentE.frame));
    self.ruleBackgroundView.centerX = SCREEN_WIDTH / 2.0;
    self.ruleBackgroundView.centerY = self.frame.size.height / 2.0;
    self.ruleBackgroundView.tag = 1001;
    self.ruleBackgroundView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [self showView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag == 1001) {
        return NO;
    }
    return YES;
}

- (void)releaseView
{
    [self hideView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeTheRuleview:)]) {
        [self.delegate closeTheRuleview:self];
    }
}

- (UIView *)ruleBackgroundView
{
    if (!_ruleBackgroundView) {
        _ruleBackgroundView = [[UIView alloc] init];
        _ruleBackgroundView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
        _ruleBackgroundView.layer.cornerRadius = 10.f;
    }
    return _ruleBackgroundView;
}

//打开弹窗
- (void)showView {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.ruleBackgroundView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);;
    } completion:nil];
}

//关闭弹窗
- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.ruleBackgroundView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
