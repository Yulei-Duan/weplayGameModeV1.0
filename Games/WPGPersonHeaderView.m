//
//  WPGPersonHeaderView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGPersonHeaderView.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>
#import "NSTimer+WPGBlockSupport.h"

static CGFloat sIntervalTime = 5.f;

@implementation WPGPersonHeaderView

- (void)dealloc
{
    [_upqueryNoticeTimer invalidate];
    _upqueryNoticeTimer = nil;
}

- (void)upstartQueryTimer
{
    
    [self upstopQueryTimer];
    
    if (nil == _upqueryNoticeTimer) {
        __weak typeof(self) weakSelf = self;
        _upqueryNoticeTimer = [NSTimer wpg_scheduledTimerWithTimeInterval:sIntervalTime block:^{
            __strong typeof(self) strongself = weakSelf;
            [strongself liuxingappear];
        } repeats:YES];
    }
    
}

- (void)upstopQueryTimer
{
    
    if (self.upqueryNoticeTimer) {
        
        [self.upqueryNoticeTimer invalidate];
        _upqueryNoticeTimer = nil;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame WithMineCenter:(BOOL)minePersonCenter
{
    if (self = [super initWithFrame:frame]) {
        _minePersonCenter = minePersonCenter;
        [self addUIView];
    }
    return self;
}

- (void)addUIView
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.gobackImageView];
    [self addSubview:self.rightBtnImageView];
    [self addSubview:self.gobackView];
    [self addSubview:self.rightBtnView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.genderNamedView];
    [self addSubview:self.gameLevelImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.locationLabel];
    [self addSubview:self.progressbar_bottomView];
    [self addSubview:self.progressbar_topView];
    [self addSubview:self.levelLabel];
    [self addSubview:self.levelNameLabel];
    [self addSubview:self.expImageView];
    [self addSubview:self.expLabel];
    [self addSubview:self.levelImageView];
    [self upstartQueryTimer];
    //[self makeAnimitionVoid];
    if (_minePersonCenter) {
        [self adjustMineViewFrame];
    }
    else {
        [self adjustOtherViewFrame];
    }
    
    UITapGestureRecognizer *leftGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftBtnVoid)];
    UITapGestureRecognizer *rightGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickrightBtnVoid)];
    self.rightBtnView.userInteractionEnabled = YES;
    [self.rightBtnView addGestureRecognizer:rightGestureRecognizer];
    [self.gobackView addGestureRecognizer:leftGestureRecognizer];
}

- (void)liuxingappear
{
    CGFloat x1 = -150;
    CGFloat y1 = 0;
    self.liuxingView.frame = CGRectMake(x1, y1, 100, 67);
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.liuxingView.frame = CGRectMake((self.bounds.size.height)/67.0*100+x1 ,self.bounds.size.height, 100, 67);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addDataWithModel:(WPGUserinfoModel *)dataModel
{
    if (!dataModel) {
        return;
    }
    
    if (dataModel.exp > dataModel.nextLevelExp) {
        dataModel.exp = dataModel.nextLevelExp;
    }
    
    if (_minePersonCenter) {
        self.progressbar_topView.hidden = NO;
        self.progressbar_bottomView.hidden = NO;
        self.levelImageView.hidden = YES;
        self.levelLabel.hidden = NO;
        self.levelNameLabel.hidden = NO;
        self.expLabel.hidden = NO;
    }
    else {
        self.progressbar_topView.hidden = YES;
        self.progressbar_bottomView.hidden = YES;
        self.levelImageView.hidden = NO;
        self.levelLabel.hidden = YES;
        self.levelNameLabel.hidden = YES;
        self.expLabel.hidden = YES;
    }
    
    if (IS_NS_STRING_EMPTY(dataModel.nickname)) dataModel.nickname = @"未命名";
    if (IS_NS_STRING_EMPTY(dataModel.levelName)) dataModel.levelName = @"萌新村民";
    //self.rankLabel.text = [NSString stringWithFormat:@"%@", @(rankNum)];
    
    UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *url = [NSURL URLWithString:dataModel.avatar];
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:defImg];
    [self.genderNamedView gender:dataModel.gender age:dataModel.age];
    
    NSURL *url_winsLevelIcon = [NSURL URLWithString:dataModel.winsLevelIcon];
    [self.gameLevelImageView sd_setImageWithURL:url_winsLevelIcon placeholderImage:defImg];
    
    self.nameLabel.text = dataModel.nickname;
    
    if (IS_NS_STRING_EMPTY(dataModel.city) && IS_NS_STRING_EMPTY(dataModel.province)) {
        self.locationLabel.text = @"地区未知";
    }
    if (IS_NS_STRING_EMPTY(dataModel.city) && !IS_NS_STRING_EMPTY(dataModel.province)) {
        self.locationLabel.text = dataModel.province;
    }
    if (!IS_NS_STRING_EMPTY(dataModel.city) && IS_NS_STRING_EMPTY(dataModel.province)) {
        self.locationLabel.text = dataModel.city;
    }
    if (!IS_NS_STRING_EMPTY(dataModel.city) && !IS_NS_STRING_EMPTY(dataModel.province)) {
        self.locationLabel.text = [NSString stringWithFormat:@"%@ %@", dataModel.province, dataModel.city];
    }
    
    if (_minePersonCenter) {
        self.expLabel.text = [NSString stringWithFormat:@"%@/%@", @(dataModel.exp), @(dataModel.nextLevelExp)];
        self.levelLabel.text = [NSString stringWithFormat:@"Lv.%@", @(dataModel.level)];
        self.levelNameLabel.text = dataModel.levelName;
        [self adjustMineViewFrame];
        CGFloat expRate;
        if (dataModel.nextLevelExp) {
            expRate = dataModel.exp*1.0/dataModel.nextLevelExp*1.0;
        }
        else {
            expRate = 0;
        }
        [self getExp:expRate];
    }
    else {
        self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_personal_level%@", @(dataModel.level)]];
        [self adjustOtherViewFrame];
    }
    [self addProgressColor];
}

- (void)getExp:(CGFloat)expRate
{
    CGFloat progressbarLength = SCREEN_WIDTH - 80;
    self.progressbar_topView.frame = CGRectMake(40, CGRectGetMaxY(self.avatarImageView.frame)+74, progressbarLength*expRate, 8);
}

- (void)adjustMineViewFrame
{
    CGFloat centerX = SCREEN_WIDTH / 2.0;
    self.gobackImageView.frame = CGRectMake(9, 31, 24, 24);
    self.rightBtnImageView.frame = CGRectMake(SCREEN_WIDTH-34, 34, 24, 24);
    self.avatarImageView.frame = CGRectMake(0, 53, 80, 80);
    self.avatarImageView.centerX = centerX;
    
    self.genderNamedView.frame = CGRectMake(0, CGRectGetMaxY(self.avatarImageView.frame)-self.genderNamedView.bounds.size.height/2.0, self.genderNamedView.bounds.size.width, self.genderNamedView.bounds.size.height);
    self.genderNamedView.centerX = centerX;
    
    [self.nameLabel sizeToFit];
    
    CGFloat gameLevilImageViewstartX = centerX - (self.gameLevelImageView.frame.size.width+self.nameLabel.contentSize.width+1)/2.0-10;
    self.gameLevelImageView.frame = CGRectMake(gameLevilImageViewstartX, 0, 32, 24);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.gameLevelImageView.frame)+1, CGRectGetMaxY(self.avatarImageView.frame)+15, 0, 0);
    [self.nameLabel sizeToFit];
    self.gameLevelImageView.centerY = self.nameLabel.centerY;
    
    self.locationLabel.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame)+2, 0, 0);
    [self.locationLabel sizeToFit];
    self.locationLabel.centerX = centerX;
    
    CGFloat progressbarLength = SCREEN_WIDTH - 80;
    self.progressbar_bottomView.frame = CGRectMake(40, CGRectGetMaxY(self.avatarImageView.frame)+74, progressbarLength, 8);
    self.progressbar_topView.frame = CGRectMake(40, CGRectGetMaxY(self.avatarImageView.frame)+74, progressbarLength/2.0, 8);
    
    self.levelLabel.frame = CGRectMake(40, CGRectGetMaxY(self.progressbar_bottomView.frame)+5, 0, 0);
    [self.levelLabel sizeToFit];
    
    self.levelNameLabel.frame = CGRectMake(CGRectGetMaxX(self.levelLabel.frame)+4, 0, 0, 0);
    [self.levelNameLabel sizeToFit];
    self.levelNameLabel.centerY = self.levelLabel.centerY;
    
    self.expImageView.frame = CGRectMake(CGRectGetMaxX(self.progressbar_bottomView.frame)-11, 0, 11, 13);
    self.expImageView.centerY = self.levelLabel.centerY;
    
    [self.expLabel sizeToFit];
    self.expLabel.frame = CGRectMake(CGRectGetMinX(self.expImageView.frame)-2-self.expLabel.contentSize.width, 0, 0, 0);
    [self.expLabel sizeToFit];
    self.expLabel.centerY = self.levelNameLabel.centerY;
    
    self.gobackView.centerX = self.gobackImageView.centerX;
    self.gobackView.centerY = self.gobackImageView.centerY;
    
    self.rightBtnView.centerX = self.rightBtnImageView.centerX;
    self.rightBtnView.centerY = self.rightBtnImageView.centerY;
    self.rightBtnImageView.image = IDSImageNamed(@"ic_nav_setup_w");
    [self addProgressColor];
}

- (void)adjustOtherViewFrame
{
    CGFloat centerX = SCREEN_WIDTH / 2.0;
    self.gobackImageView.frame = CGRectMake(9, 31, 24, 24);
    self.rightBtnImageView.frame = CGRectMake(SCREEN_WIDTH-34, 34, 24, 24);
    self.avatarImageView.frame = CGRectMake(0, 72, 80, 80);
    self.avatarImageView.centerX = centerX;
    
    self.genderNamedView.frame = CGRectMake(0, CGRectGetMaxY(self.avatarImageView.frame)-self.genderNamedView.bounds.size.height/2.0, self.genderNamedView.bounds.size.width, self.genderNamedView.bounds.size.height);
    self.genderNamedView.centerX = centerX;
    
    [self.nameLabel sizeToFit];
    
    CGFloat gameLevilImageViewstartX = centerX - (self.levelImageView.frame.size.width+self.gameLevelImageView.frame.size.width+self.nameLabel.contentSize.width+7-4)/2.0;
    self.gameLevelImageView.frame = CGRectMake(gameLevilImageViewstartX, 0, 32, 24);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.gameLevelImageView.frame)+1, CGRectGetMaxY(self.avatarImageView.frame)+20, 0, 0);
    [self.nameLabel sizeToFit];
    self.gameLevelImageView.centerY = self.nameLabel.centerY;
    
    self.levelImageView.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+2, 0, 33, 14);
    self.levelImageView.centerY = self.nameLabel.centerY;
    
    self.locationLabel.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame)+7, 0, 0);
    [self.locationLabel sizeToFit];
    self.locationLabel.centerX = centerX;
    
    self.gobackView.centerX = self.gobackImageView.centerX;
    self.gobackView.centerY = self.gobackImageView.centerY;
    
    self.rightBtnView.centerX = self.rightBtnImageView.centerX;
    self.rightBtnView.centerY = self.rightBtnImageView.centerY;
    
    self.rightBtnImageView.image = IDSImageNamed(@"ic_nav_report_w");
    [self addProgressColor];
}

- (void)clickLeftBtnVoid
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLeftBtnAction:)]) {
        [self.delegate clickLeftBtnAction:self];
    }
}

- (void)clickrightBtnVoid
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRightBtnAction:)]) {
        [self.delegate clickRightBtnAction:self];
    }
}

- (void)makeAnimitionVoid
{
    self.starAImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
    self.starBImageView.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, 250);
    [UIView animateWithDuration:10 delay:0.0f options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.starAImageView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 250);
                         self.starBImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
                     } completion:^(BOOL finished) {
                         self.starAImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
                         self.starBImageView.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, 250);
                     }];
    [UIView setAnimationsEnabled:YES];
}

-(void)addProgressColor
{
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[ColorUtil cl_colorWithHexString:@"#F9B433"].CGColor,
                       (id)[ColorUtil cl_colorWithHexString:@"#FFEC63"].CGColor,
                       nil];
    [gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
    [gradLayer setEndPoint:CGPointMake(1.0f, 0.0f)];
    CGFloat progressbarLength = SCREEN_WIDTH - 80;
    [gradLayer setFrame:CGRectMake(0, 0, progressbarLength, 8)];
    [self.progressbar_topView.layer addSublayer:gradLayer];
    self.progressbar_topView.layer.masksToBounds = YES;
}

- (UIImageView *)gobackImageView
{
    if (!_gobackImageView) {
        _gobackImageView = [[UIImageView alloc] init];
        _gobackImageView.image = [UIImage imageNamed:@"ic_nav_back_w"];
        _gobackImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _gobackImageView;
}

- (UIImageView *)rightBtnImageView
{
    if (!_rightBtnImageView) {
        _rightBtnImageView = [[UIImageView alloc] init];
        _rightBtnImageView.image = [UIImage imageNamed:@"ic_nav_setup_w"];
        _rightBtnImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightBtnImageView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 253+5+5)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.image = [UIImage imageNamed:@"bg_personal_sky"];
        _backgroundImageView.layer.masksToBounds = YES;
        [_backgroundImageView addSubview:self.starAImageView];
        [_backgroundImageView addSubview:self.starBImageView];
        [_backgroundImageView addSubview:self.liuxingView];
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}

- (UIImageView *)liuxingView
{
    if (!_liuxingView) {
        _liuxingView = [[UIImageView alloc] init];
        _liuxingView.contentMode = UIViewContentModeScaleToFill;
        _liuxingView.image = [UIImage imageNamed:@"bg_personal_meteor"];
    }
    return _liuxingView;
}

- (UIImageView *)starAImageView
{
    if (!_starAImageView) {
        _starAImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _starAImageView.contentMode = UIViewContentModeScaleAspectFill;
        _starAImageView.image = [UIImage imageNamed:@"bg_personal_star"];
        _starAImageView.layer.masksToBounds = YES;
    }
    return _starAImageView;
}

- (UIImageView *)starBImageView
{
    if (!_starBImageView) {
        _starBImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _starBImageView.contentMode = UIViewContentModeScaleAspectFill;
        _starBImageView.image = [UIImage imageNamed:@"bg_personal_star"];
        _starBImageView.layer.masksToBounds = YES;
    }
    return _starBImageView;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        _avatarImageView.image = defImg;
        _avatarImageView.layer.cornerRadius = 40.f;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.borderWidth = 3;
    }
    return _avatarImageView;
}

- (IDSGenderLeviNamedView *)genderNamedView
{
    if (!_genderNamedView) {
        _genderNamedView = [[IDSGenderLeviNamedView alloc] initWithGender:0 age:1];
    }
    return _genderNamedView;
}

- (UIImageView *)gameLevelImageView
{
    if (!_gameLevelImageView) {
        _gameLevelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 24)];
        _gameLevelImageView.image = [UIImage imageNamed:@"ic_chart_badge1"];
        _gameLevelImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gameLevelImageView.layer.masksToBounds = YES;
    }
    return _gameLevelImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:19];
        _nameLabel.textColor = [ColorUtil cl_colorWithHexString:@"$FFFFFF"];
        _nameLabel.text = @"查无此人";
    }
    return _nameLabel;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _locationLabel.textColor = [ColorUtil cl_colorWithHexString:@"$FFFFFF"];
        _locationLabel.text = @"广东 深圳";
        _locationLabel.alpha = 0.7f;
    }
    return _locationLabel;
}

- (UIView *)progressbar_topView
{
    if (!_progressbar_topView) {
        _progressbar_topView = [[UIView alloc] init];
        //_progressbar_topView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FFD86F"];
        _progressbar_topView.layer.cornerRadius = 4.0f;
    }
    return _progressbar_topView;
}

- (UIView *)progressbar_bottomView
{
    if (!_progressbar_bottomView) {
        _progressbar_bottomView = [[UIView alloc] init];
        _progressbar_bottomView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#000000"];
        _progressbar_bottomView.alpha = 0.2;
        _progressbar_bottomView.layer.cornerRadius = 4.0f;
    }
    return _progressbar_bottomView;
}

- (UILabel *)levelLabel
{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _levelLabel.textColor = [ColorUtil cl_colorWithHexString:@"$FFFFFF"];
        _levelLabel.text = @"Lv.1";
        _levelLabel.alpha = 0.6f;
    }
    return _levelLabel;
}

- (UILabel *)levelNameLabel
{
    if (!_levelNameLabel) {
        _levelNameLabel = [[UILabel alloc] init];
        _levelNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        _levelNameLabel.textColor = [ColorUtil cl_colorWithHexString:@"$FFFFFF"];
        _levelNameLabel.text = @"萌新村民";
        _levelNameLabel.alpha = 0.6f;
    }
    return _levelNameLabel;
}

- (UILabel *)expLabel
{
    if (!_expLabel) {
        _expLabel = [[UILabel alloc] init];
        _expLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _expLabel.textColor = [ColorUtil cl_colorWithHexString:@"$FFFFFF"];
        _expLabel.text = @"100/200";
        _expLabel.alpha = 0.6f;
    }
    return _expLabel;
}

- (UIImageView *)expImageView
{
    if (!_expImageView) {
        _expImageView = [[UIImageView alloc] init];
        _expImageView.image = [UIImage imageNamed:@"ic_personal_exp"];
        _expImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _expImageView;
}

- (UIImageView *)levelImageView
{
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 14)];
        _levelImageView.image = [UIImage imageNamed:@"img_personal_level1"];
        _levelImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _levelImageView;
}

- (UIView *)gobackView
{
    if (!_gobackView) {
        _gobackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _gobackView;
}

- (UIView *)rightBtnView
{
    if (!_rightBtnView) {
        _rightBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _rightBtnView;
}

@end
