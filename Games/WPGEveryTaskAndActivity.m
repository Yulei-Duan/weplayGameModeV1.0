//
//  WPGEveryTaskAndActivity.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/12.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGEveryTaskAndActivity.h"

@interface WPGEveryTaskAndActivity()

@property (nonatomic, strong) UIImageView *taskView;
@property (nonatomic, strong) UIImageView *activityView;
@property (nonatomic, strong) UIImageView *taskImageView;
@property (nonatomic, strong) UIImageView *activityImageView;
@property (nonatomic, strong) UILabel *taskLabel;
@property (nonatomic, strong) UILabel *activityLabel;

@end

@implementation WPGEveryTaskAndActivity

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    [self addSubview:self.taskView];
    [self.taskView addSubview:self.taskImageView];
    [self.taskView addSubview:self.taskLabel];
    [self.taskView addSubview:self.redViewA];
    
    // startX 为图片的初始X坐标
    float startX = (self.taskView.frame.size.width - self.taskLabel.contentSize.width - 32 - 6) / 2.0;
    self.taskImageView.frame = CGRectMake(startX, 0, 32, 32);
    self.taskImageView.centerY = self.taskView.frame.size.height / 2.0 -1;
    self.redViewA.frame = CGRectMake(CGRectGetMaxX(self.taskImageView.frame)-9+2, CGRectGetMinY(self.taskImageView.frame)+1, 10, 10);
    [self.taskLabel sizeToFit];
    self.taskLabel.frame = CGRectMake(CGRectGetMaxX(self.taskImageView.frame)+6, 0, self.taskLabel.contentSize.width, self.taskLabel.contentSize.height);
    self.taskLabel.centerY = self.taskImageView.centerY;

    [self addSubview:self.activityView];
    [self.activityView addSubview:self.activityImageView];
    [self.activityView addSubview:self.activityLabel];
    [self.activityView addSubview:self.redViewB];
    
    self.activityImageView.frame = CGRectMake(startX, 0, 32, 32);
    self.activityImageView.centerY = self.activityView.frame.size.height / 2.0 -1;
    self.redViewB.frame = CGRectMake(CGRectGetMaxX(self.activityImageView.frame)-9+2, CGRectGetMinY(self.activityImageView.frame)+1, 10, 10);
    [self.activityLabel sizeToFit];
    self.activityLabel.frame = CGRectMake(CGRectGetMaxX(self.activityImageView.frame)+6, 0, self.activityLabel.contentSize.width, self.activityLabel.contentSize.height);
    self.activityLabel.centerY = self.taskImageView.centerY;
    
    UITapGestureRecognizer *recognizer_task = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTaskPage)];
    [self.taskView addGestureRecognizer:recognizer_task];
    self.taskView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *recognizer_activity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openActivityPage)];
    [self.activityView addGestureRecognizer:recognizer_activity];
    self.activityView.userInteractionEnabled = YES;
    self.redViewA.hidden = YES;
    self.redViewB.hidden = YES;
}

- (void)openTaskPage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openEveryTaskPage:)]) {
        [self.delegate openEveryTaskPage:self];
    }
}

- (void)openActivityPage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openActivityPage:)]) {
        [self.delegate openActivityPage:self];
    }
}

- (UIImageView *)taskView
{
    if (!_taskView) {
        _taskView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH-40)/2.0, 50)];
        _taskView.image = [UIImage imageNamed:@"btn_game_task_bottom"];
        _taskView.contentMode = UIViewContentModeScaleAspectFill;
        _taskView.layer.masksToBounds = YES;
    }
    return _taskView;
}

- (UIImageView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0+5, 0, (SCREEN_WIDTH-40)/2.0, 50)];
        _activityView.image = [UIImage imageNamed:@"btn_game_activity_bottom"];
        _activityView.contentMode = UIViewContentModeScaleAspectFill;
        _activityView.layer.masksToBounds = YES;
    }
    return _activityView;
}

- (UIImageView *)taskImageView
{ 
    if (!_taskImageView) {
        _taskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(34, 0, 32, 32)];
        _taskImageView.image = [UIImage imageNamed:@"ic_game_task"];
        _taskImageView.contentMode = UIViewContentModeScaleAspectFill;
        _taskImageView.layer.masksToBounds = YES;
    }
    return _taskImageView;
}

- (UIImageView *)activityImageView
{
    if (!_activityImageView) {
        _activityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(34, 0, 32, 32)];
        _activityImageView.image = [UIImage imageNamed:@"ic_game_activity"];
        _activityImageView.contentMode = UIViewContentModeScaleAspectFill;
        _activityImageView.layer.masksToBounds = YES;
    }
    return _activityImageView;
}

- (UILabel *)taskLabel
{
    if (!_taskLabel) {
        _taskLabel = [[UILabel alloc] init];
        _taskLabel.text = @"每日任务";
        _taskLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _taskLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _taskLabel;
}

- (UILabel *)activityLabel
{
    if (!_activityLabel) {
        _activityLabel = [[UILabel alloc] init];
        _activityLabel.text = @"限时活动";
        _activityLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _activityLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _activityLabel;
}

- (UIView *)redViewA
{
    if (!_redViewA) {
        _redViewA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _redViewA.layer.cornerRadius = 9/2.0f;
        _redViewA.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
//        _redViewA.layer.borderColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"].CGColor;
//        _redViewA.layer.borderWidth = 1.f;
    }
    return _redViewA;
}

- (UIView *)redViewB
{
    if (!_redViewB) {
        _redViewB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _redViewB.layer.cornerRadius = 9/2.0f;
        _redViewB.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
        
    }
    return _redViewB;
}

@end
