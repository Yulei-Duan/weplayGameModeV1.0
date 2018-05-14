//
//  WPGameLevelView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGameLevelView.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>

@implementation WPGameLevelView

- (void)dealloc
{
    IDSLOG(@"WPGameLevelView dealloc");
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
    [self addSubview:self.animationView];
    [self addSubview:self.titleImageView];
    [self addSubview:self.levelImageView];
    [self addSubview:self.taskBannerImageView];
    [self addSubview:self.closeImageView];
    [self addSubview:self.titleLabel];
    self.userInteractionEnabled = YES;
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
    
    self.levelImageView.frame = CGRectMake(0, CGRectGetMaxY(self.titleImageView.frame)+81, 195, 155);
    self.levelImageView.centerX = centerX;
    
    self.taskBannerImageView.frame = CGRectMake(0, CGRectGetMaxY(self.levelImageView.frame)+8, 209, 70);
    self.taskBannerImageView.centerX = centerX;
    
    self.closeImageView.frame = CGRectMake(0, CGRectGetMaxY(self.taskBannerImageView.frame)+81, 35, 35);
    if (IS_IPHONE_5) {
        self.closeImageView.frame = CGRectMake(0, CGRectGetMaxY(self.taskBannerImageView.frame)+81-35, 35, 35);
    }
    self.closeImageView.centerX = centerX;
    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMinY(self.taskBannerImageView.frame)+14, 0, 0);
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = centerX;
    
    self.animationView.centerX = self.levelImageView.centerX;
    self.animationView.centerY = self.levelImageView.centerY-5;
}

- (void)getlevelImageUrl:(NSString *)imageUrl rankName:(NSString *)rankName isUp:(BOOL)isup;
{
    if (isup) {
        self.titleImageView.image = [UIImage imageNamed:@"img_task_title_upgrade"];
        self.taskBannerImageView.image = [UIImage imageNamed:@"img_task_banner"];
    }
    else {
        self.titleImageView.image = [UIImage imageNamed:@"img_task_title_down"];
        self.taskBannerImageView.image = [UIImage imageNamed:@"img_task_banner_copy"];
    }
    
    UIImage *defImg = [IDSImageManager defaultAvatar:SquareStyle];
    NSURL *avatar_url = [NSURL URLWithString:imageUrl];
    [self.levelImageView sd_setImageWithURL:avatar_url placeholderImage:defImg];
    self.titleLabel.text = rankName;
    [self adjustViewFrame];
}

- (void)closeTheView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeLevelView:)]) {
        [self.delegate closeLevelView:self];
        [self removeFromSuperview];
    }
}

- (UIImageView *)titleImageView
{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 31)];
        _titleImageView.image = [UIImage imageNamed:@"img_task_title_upgrade"];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _titleImageView;
}

- (UIImageView *)levelImageView
{
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 195, 155)];
        _levelImageView.image = [UIImage imageNamed:@"img_task_king"];
        _levelImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _levelImageView;
}

- (UIImageView *)taskBannerImageView
{
    if (!_taskBannerImageView) {
        _taskBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 209, 70)];
        _taskBannerImageView.image = [UIImage imageNamed:@"img_task_banner"];
        _taskBannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _taskBannerImageView;
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
        _titleLabel.text = @"最强王者";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:23];
        _titleLabel.textColor = NF_Color_C1;
    }
    return _titleLabel;
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
