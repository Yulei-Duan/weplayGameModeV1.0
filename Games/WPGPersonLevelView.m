//
//  WPGPersonLevelView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/24.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGPersonLevelView.h"

@implementation WPGPersonLevelView

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
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = .9f;
    effectView.frame = self.frame;
    [self addSubview:effectView];
//    self.backgroundColor = [ColorUtil cl_colorWithHexString:@"#000000" alpha:0.7];
    [self addSubview:self.animationView];
    [self addSubview:self.titleImageView];
    [self addSubview:self.levelImageView];
    [self addSubview:self.closeImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.levelLabel];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTheView)];
    [self.closeImageView addGestureRecognizer:recognizer];
    self.closeImageView.userInteractionEnabled = YES;
    [self adjustViewFrame];
    [self.animationView playWithCompletion:^(BOOL animationFinished) {
        
    }];
}

- (void)adjustViewFrame
{
    CGFloat centerX = SCREEN_WIDTH / 2.0;
    self.titleImageView.frame = CGRectMake(0, 121, 130, 31);
    self.titleImageView.centerX = centerX;
    
    self.levelImageView.frame = CGRectMake(0, CGRectGetMaxY(self.titleImageView.frame)+86, 140, 157);
    self.levelImageView.centerX = centerX;
    
    self.closeImageView.frame = CGRectMake(0, CGRectGetMaxY(self.levelImageView.frame)+156, 35, 35);
    if (IS_IPHONE_5) {
        self.closeImageView.frame = CGRectMake(0, CGRectGetMaxY(self.levelImageView.frame)+156-35, 35, 35);
    }
    self.closeImageView.centerX = centerX;
    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.levelImageView.frame)+16, 0, 0);
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = centerX;
    
    self.levelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)-5, 0, 0);
    [self.levelLabel sizeToFit];
    self.levelLabel.centerX = centerX;
    
    self.animationView.centerX = self.levelImageView.centerX;
    self.animationView.centerY = self.levelImageView.centerY-17;
}

- (void)closeTheView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeLevelView:)]) {
        [self.delegate closeLevelView:self];
    }
}

- (void)setLevel:(NSString *)level
{
    CGFloat centerX = SCREEN_WIDTH / 2.0;
    self.levelLabel.text = [NSString stringWithFormat:@"Lv.%@", level];
    [self.levelLabel sizeToFit];
    self.levelLabel.centerX = centerX;
}

- (UIImageView *)titleImageView
{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 31)];
        _titleImageView.image = [UIImage imageNamed:@"img_task_title_levelup"];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _titleImageView;
}

- (UIImageView *)levelImageView
{
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 157)];
        _levelImageView.image = [UIImage imageNamed:@"img_task_levelup"];
        _levelImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _levelImageView;
}

- (UIImageView *)closeImageView
{
    if (!_closeImageView) {
        _closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        _closeImageView.image = [UIImage imageNamed:@"ic_task_close"];
        _closeImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _closeImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"升级到";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _titleLabel.textColor = NF_Color_C1;
    }
    return _titleLabel;
}

- (UILabel *)levelLabel
{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.text = @"Lv.1";
        _levelLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:33];
        _levelLabel.textColor = NF_Color_C1;
    }
    return _levelLabel;
}

- (LOTAnimationView *)animationView
{
    if (!_animationView) {
        NSBundle *resourceBundle = [[NSBundle alloc] initWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"11003" ofType:@"bundle"]];
        _animationView = [LOTAnimationView animationNamed:@"11003" inBundle:resourceBundle];
        _animationView.frame = CGRectMake(0.0f, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        _animationView.backgroundColor = [UIColor clearColor];
        _animationView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _animationView;
}

@end
