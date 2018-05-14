//
//  WPGAchieveAwardView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGAchieveAwardView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Lottie/Lottie.h>

@implementation WPGAchieveAwardView

- (void)dealloc
{
    _avAudioPlayer = nil;
    IDSLOG(@"WPGAchieveAwardView dealloc");
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
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = .9f;
    effectView.frame = self.frame;
    [self addSubview:effectView];
    [self addSubview:self.awardView];
    [self addSubview:self.coinImageView];
    [self addSubview:self.expImageView];
    [self addSubview:self.coinUnitLabel];
    [self addSubview:self.expUnitLabel];
    [self addSubview:self.coinValueLabel];
    [self addSubview:self.expValueLabel];
    [self addSubview:self.animationViewA];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTheView)];
    [self addGestureRecognizer:tapGesture];
    [self adjustViewFrame];
}

- (void)addSoundVoid
{
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"getTaskAward" ofType:@"mp3"]] error:nil];
    [_avAudioPlayer play];
}

- (void)achieveAwardWithCoin:(NSInteger)coin exp:(NSInteger)exp
{
    self.coinValueLabel.text = [NSString stringWithFormat:@"+%@", @(coin)];
    [self.coinValueLabel sizeToFit];
    
    self.expValueLabel.text = [NSString stringWithFormat:@"+%@", @(exp)];
    [self.expValueLabel sizeToFit];
    
    [self adjustViewFrame];
    [self addSoundVoid];
    [self.animationViewA playWithCompletion:^(BOOL animationFinished) {
        
    }];
}

- (void)adjustViewFrame
{
    CGFloat centerX = SCREEN_WIDTH / 2.0;
    //self.backgroundColor = [ColorUtil cl_colorWithHexString:@"#000000" alpha:0.7];
    self.awardView.frame = CGRectMake(0, 120, 130, 31);
    self.awardView.centerX = centerX;
    
    CGFloat startX = ((SCREEN_WIDTH - 110 - 105) / (73*2+15.0)) * 73;
    self.coinImageView.frame = CGRectMake(startX, CGRectGetMaxY(self.awardView.frame)+110, 110, 114);
    self.expImageView.frame = CGRectMake(SCREEN_WIDTH-startX-105, CGRectGetMaxY(self.awardView.frame)+110, 105, 114);
    
    self.coinUnitLabel.frame = CGRectMake(0, CGRectGetMaxY(self.coinImageView.frame)+20, 0, 0);
    [self.coinUnitLabel sizeToFit];
    self.coinUnitLabel.centerX = self.coinImageView.centerX;
    
    self.expUnitLabel.frame = CGRectMake(0, CGRectGetMaxY(self.expImageView.frame)+20, 0, 0);
    [self.expUnitLabel sizeToFit];
    self.expUnitLabel.centerX = self.expImageView.centerX;
    
    self.coinValueLabel.frame = CGRectMake(0, CGRectGetMaxY(self.coinUnitLabel.frame), 0, 0);
    [self.coinValueLabel sizeToFit];
    self.coinValueLabel.centerX = self.coinImageView.centerX;
    
    self.expValueLabel.frame = CGRectMake(0, CGRectGetMaxY(self.expUnitLabel.frame), 0, 0);
    [self.expValueLabel sizeToFit];
    self.expValueLabel.centerX = self.expImageView.centerX;
    self.animationViewA.centerY = self.expImageView.centerY+10;
}


- (void)closeTheView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeTheView:)]) {
        [self.delegate closeTheView:self];
    }
}

- (UIImageView *)awardView
{
    if (!_awardView) {
        _awardView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 31)];
        _awardView.contentMode = UIViewContentModeScaleAspectFill;
        _awardView.image = [UIImage imageNamed:@"img_task_title_reward"];
    }
    return _awardView;
}

- (UIImageView *)coinImageView
{
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 114)];
        _coinImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coinImageView.image = [UIImage imageNamed:@"img_task_gold"];
    }
    return _coinImageView;
}

- (UIImageView *)expImageView
{
    if (!_expImageView) {
        _expImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 105, 114)];
        _expImageView.contentMode = UIViewContentModeScaleAspectFill;
        _expImageView.image = [UIImage imageNamed:@"img_task_exp"];
    }
    return _expImageView;
}

- (UILabel *)coinUnitLabel
{
    if (!_coinUnitLabel) {
        _coinUnitLabel = [[UILabel alloc] init];
        _coinUnitLabel.text = @"金币";
        _coinUnitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _coinUnitLabel.textColor = NF_Color_C1;
    }
    return _coinUnitLabel;
}

- (UILabel *)expUnitLabel
{
    if (!_expUnitLabel) {
        _expUnitLabel = [[UILabel alloc] init];
        _expUnitLabel.text = @"经验值";
        _expUnitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _expUnitLabel.textColor = NF_Color_C1;
    }
    return _expUnitLabel;
}

- (UILabel *)coinValueLabel
{
    if (!_coinValueLabel) {
        _coinValueLabel = [[UILabel alloc] init];
        _coinValueLabel.text = @" ";
        _coinValueLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _coinValueLabel.textColor = NF_Color_C1;
    }
    return _coinValueLabel;
}

- (UILabel *)expValueLabel
{
    if (!_expValueLabel) {
        _expValueLabel = [[UILabel alloc] init];
        _expValueLabel.text = @" ";
        _expValueLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _expValueLabel.textColor = NF_Color_C1;
    }
    return _expValueLabel;
}

- (LOTAnimationView *)animationViewA
{
    if (!_animationViewA) {
        NSBundle *resourceBundle = [[NSBundle alloc] initWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"10009" ofType:@"bundle"]];
        _animationViewA = [LOTAnimationView animationNamed:@"10009" inBundle:resourceBundle];
        _animationViewA.frame = CGRectMake(0.0f, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        _animationViewA.backgroundColor = [UIColor clearColor];
        _animationViewA.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _animationViewA;
}

@end
