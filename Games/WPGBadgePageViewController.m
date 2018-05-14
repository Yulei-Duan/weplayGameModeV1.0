//
//  WPGBadgePageViewController.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGBadgePageViewController.h"
#import "WPGProfileCenterModel.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>
#import "IDSUpDownBallonView.h"
#import "WPGBrageRequest.h"
#import "IDSSharedPopupWindow.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WPGBadgePageViewController () <CAAnimationDelegate>

@property (nonatomic, assign) NSInteger animationCountTop;
@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;
@property (nonatomic, assign) NSInteger animationCountBottom;

@end

@implementation WPGBadgePageViewController

- (void)dealloc
{
    _avAudioPlayer = nil;
    IDSLOG(@"WPGBadgePageViewController dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)preferredNavigationBarHidden
{
    return YES;
}

- (void)initWithUI
{
    _animationCountBottom = _animationCountTop = 1001;
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.badgeImageView];
    [self.backgroundImageView addSubview:self.shadowImageView];
    [self.backgroundImageView addSubview:self.leftImageView];
    [self.backgroundImageView addSubview:self.rightImageView];
    [self.view addSubview:self.returnImageView];
    [self.view addSubview:self.returnView];
    [self.backgroundImageView addSubview:self.timeLabel];
    [self.backgroundImageView addSubview:self.titleLabel];
    [self.backgroundImageView addSubview:self.descLabel];
    [self.view addSubview:self.achieveImageView];
    [self.view addSubview:self.achieveBtnLabel];
    
    UITapGestureRecognizer *leftGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickreturnBtnVoid)];
    [self.returnView addGestureRecognizer:leftGestureRecognizer];
    self.returnView.userInteractionEnabled = YES;
    [self adjustViewFrame];
}

- (void)adjustViewFrame
{
    CGFloat centerX = SCREEN_WIDTH / 2.0;
    self.backgroundImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.badgeImageView.frame = CGRectMake(0, 96, 194, 220);
    self.badgeImageView.centerX = centerX;
    
    self.shadowImageView.frame = CGRectMake(0, CGRectGetMaxY(self.badgeImageView.frame)+20, 279, 20);
    self.shadowImageView.centerX = centerX;
    
    self.timeLabel.frame = CGRectMake(0, CGRectGetMaxY(self.shadowImageView.frame)+43, 0, 0);
    [self.timeLabel sizeToFit];
    self.timeLabel.centerX = centerX;
    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame)+1, 0, 0);
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = centerX;
    
    self.descLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+5, 0, 0);
    [self.descLabel sizeToFit];
    self.descLabel.centerX = centerX;
    
    self.leftImageView.frame = CGRectMake(CGRectGetMinX(self.descLabel.frame)-5-2, CGRectGetMinY(self.descLabel.frame), 5, 11);
    self.rightImageView.frame = CGRectMake(CGRectGetMaxX(self.descLabel.frame)+1, CGRectGetMinY(self.descLabel.frame)+12, 5, 11);
    
    self.returnImageView.frame = CGRectMake(9, 31, 24, 24);
    self.returnView.frame = CGRectMake(0, 0, 50, 50);
    self.returnView.centerX = self.returnImageView.centerX;
    self.returnView.centerY = self.returnImageView.centerY;
    
    self.achieveImageView.frame = CGRectMake(0, CGRectGetMaxY(self.descLabel.frame)+52, 210, 49);
    self.achieveImageView.centerX = centerX;
    self.achieveBtnLabel.frame = CGRectMake(0, CGRectGetMinY(self.achieveImageView.frame)+10, 0, 0);
    [self.achieveBtnLabel sizeToFit];
    self.achieveBtnLabel.centerX = centerX;
    
    if (IS_IPHONE_5) {
        self.achieveImageView.frame = CGRectMake(0, CGRectGetMaxY(self.descLabel.frame)+2, 210, 49);
        self.achieveImageView.centerX = centerX;
        self.achieveBtnLabel.frame = CGRectMake(0, CGRectGetMinY(self.achieveImageView.frame)+10, 0, 0);
        [self.achieveBtnLabel sizeToFit];
        self.achieveBtnLabel.centerX = centerX;
    }
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSharePage)];
    self.achieveImageView.userInteractionEnabled = YES;
    [self.achieveImageView addGestureRecognizer:gesture];
}

- (void)initWithData:(WPGAchieveMentListModel *)achieveModel isMine:(BOOL)isMine
{
    if (!achieveModel) {
        [self goBack];
    }
    _model = achieveModel;
    
    _isMine = isMine;
    if (_isMine) {
        self.achieveImageView.hidden = NO;
        self.achieveBtnLabel.hidden = NO;
        //[self animationVoid];
    }
    else {
        self.achieveImageView.hidden = YES;
        self.achieveBtnLabel.hidden = YES;
    }
    
    if (!achieveModel.status) {
        self.timeLabel.hidden = YES;
    }
    else {
        self.timeLabel.hidden = NO;
    }
    
    if (IS_NS_STRING_EMPTY(achieveModel.date)) achieveModel.date = @" ";
    if (IS_NS_STRING_EMPTY(achieveModel.name)) achieveModel.name = @" ";
    if (IS_NS_STRING_EMPTY(achieveModel.intro)) achieveModel.intro = @" ";
    
    UIImage *defImg = [IDSImageManager defaultAvatar:SquareStyle];
    NSURL *avatar_url = [NSURL URLWithString:achieveModel.largeIconUrl];
    [self.badgeImageView sd_setImageWithURL:avatar_url placeholderImage:defImg];
    self.timeLabel.text = achieveModel.date;
    self.titleLabel.text = achieveModel.name;
    self.descLabel.text = achieveModel.intro;
    
    self.titleLabel.textColor = NF_Color_C1;
    // status 解锁状态 0未解锁 1已解锁带new 2已解锁
    if (achieveModel.status == 0) {
        [self noBadgeStatus];
        if (_isMine) {
            self.titleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#AA92DD"];
        }
    }
    else {
        if (_isMine) {
            [self ballonViewAnimation];
            [self addSoundVoid];
        }
        
        [self getBadgeStatus];
        if (![AppUtil isInstallQQ] && ![AppUtil isInstallWX]) {
            self.achieveImageView.hidden = YES;
            self.achieveBtnLabel.hidden = YES;
        }
    }
    
    [self adjustViewFrame];
    
    if (achieveModel.status == 1) {
        [self requestGetBadge:[NSString stringWithFormat:@"%@", @(achieveModel.achvId)]];
    }
}

- (void)clickreturnBtnVoid
{
    [self goBack];
}

- (void)openSharePage
{
    if (!_model) {
        self.achieveImageView.userInteractionEnabled = NO;
        return;
    }
    if (_model.status) {
        
        UIImageView *testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        testImageView.image = [self createImageWithView:self.backgroundImageView];
        UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH*115/375, SCREEN_WIDTH, SCREEN_WIDTH*115/375.0)];
        bottomView.image = [UIImage imageNamed:@"bg_personal_share"];
        [testImageView addSubview:bottomView];
        UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        newImageView.image = [self createImageWithView:testImageView];
        
        IDSSharedPopupConfig *sharedConfig = [[IDSSharedPopupConfig alloc] init];
        sharedConfig.localImage = newImageView.image;
        sharedConfig.options = IDSShareViewTypeSNSAll;
        
        [IDSSharedPopupWindow showWithConfig:sharedConfig];
    }
}

- (void)ballonViewAnimation
{
    IDSUpDownBallonView  *ballonView = [[IDSUpDownBallonView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT-20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.view addSubview:ballonView];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, 1.5*SCREEN_HEIGHT)];
    basicAnimation.duration = 6;
    basicAnimation.delegate = self;
    basicAnimation.removedOnCompletion = YES;
    basicAnimation.fillMode = kCAFillModeRemoved;
    [ballonView resumeLayer:ballonView.layer];
    
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.toValue = @(0.0);
    
    //创建动画组，来存以上的动画
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[basicAnimation,alpha];
    group.duration = 6.0;
    //设置代理
    group.delegate = self;
    
    [ballonView.layer  addAnimation:group forKey:nil];
    
    ballonView.tag = _animationCountTop++;
}

- (void)addSoundVoid
{
    /*
    NSURL *url = [[NSURL alloc] initWithString:[AppUtil urlEncodeToURLString:urlStr]];
    NSData *audioData = [NSData dataWithContentsOfURL:url];
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
     */
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"getBadgeSound" ofType:@"mp3"]] error:nil];
    [_avAudioPlayer play];
}

- (void)animationVoid
{
    self.achieveImageView.alpha = 0;
    self.achieveBtnLabel.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        self.achieveImageView.alpha = 1;
        self.achieveBtnLabel.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if (_animationCountBottom < _animationCountTop) {
            IDSUpDownBallonView *unitView = (IDSUpDownBallonView *)[self.view viewWithTag:_animationCountBottom];
            IDSLOG(@"uniView : %@",unitView);
            [unitView removeFromSuperview];
            unitView = nil;
            ++_animationCountBottom;
        }
    }
}

- (void)getBadgeStatus
{
    self.achieveImageView.image = [UIImage imageNamed:@"ic_personal_obtained_achieve"];
    self.achieveImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.achieveBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.achieveBtnLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
    self.achieveBtnLabel.text = @"炫耀一下";
}

- (void)noBadgeStatus
{
    self.achieveImageView.image = [UIImage imageNamed:@"ic_personal_obtained_noachieve"];
    self.achieveImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.achieveBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.achieveBtnLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
    self.achieveBtnLabel.text = @"成就未达成";
}

- (void)requestGetBadge:(NSString *)achieveId
{
    @weakify(self);
    [WPGBrageRequest requestGetBadgeWithAchieveId:achieveId Success:^(id responseObj) {
        //@strongify(self);
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            //[self warnUser:@"领取徽章成功"];
        }
        
    } fail:^(NSError *error) {
        @strongify(self);
        [self warnUser:@"网络请求有误，请重试！"];
    }];
}

- (UIImage *)createImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    
    //第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，设置为[UIScreen mainScreen].scale可以保证转成的图片不失真。
    //UIGraphicsBeginImageContextWithOptions(s, YES,[UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(s, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backgroundImageView.image = [UIImage imageNamed:@"bg_personal_trinket_background"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (UIImageView *)badgeImageView
{
    if (!_badgeImageView) {
        _badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 194, 220)];
        //_badgeImageView.image = [UIImage imageNamed:@"bg_personal_trinket_background"];
        _badgeImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _badgeImageView;
}

- (UIImageView *)shadowImageView
{
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 279, 20)];
        _shadowImageView.image = [UIImage imageNamed:@"img_personal_trinket_shadow"];
        _shadowImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _shadowImageView;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 11)];
        _leftImageView.image = [UIImage imageNamed:@"img_personal_trinket_left_parenthesis"];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 11)];
        _rightImageView.image = [UIImage imageNamed:@"img_personal_trinket_right_parenthesis"];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightImageView;
}

- (UIImageView *)returnImageView
{
    if (!_returnImageView) {
        _returnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        _returnImageView.image = [UIImage imageNamed:@"ic_nav_back_w"];
        _returnImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _returnImageView;
}

- (UIView *)returnView
{
    if (!_returnView) {
        _returnView = [[UIView alloc] init];
    }
    return _returnView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @" ";
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _timeLabel.textColor = NF_Color_C1;
    }
    return _timeLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @" ";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:42];
        _titleLabel.textColor = NF_Color_C1;
        _titleLabel.alpha = 0.9f;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @" ";
        _descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        _descLabel.textColor = NF_Color_C1;
        _descLabel.alpha = 0.5f;
    }
    return _descLabel;
}

- (LOTAnimationView *)animationView
{
    if (!_animationView) {
        NSBundle *resourceBundle = [[NSBundle alloc] initWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"12001" ofType:@"bundle"]];
        _animationView = [LOTAnimationView animationNamed:@"data1" inBundle:resourceBundle];
        _animationView.frame = CGRectMake(0.0f, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _animationView.backgroundColor = [UIColor clearColor];
        _animationView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _animationView;
}

- (UIImageView *)achieveImageView
{
    if (!_achieveImageView) {
        _achieveImageView = [[UIImageView alloc] init];
        _achieveImageView.image = [UIImage imageNamed:@"ic_personal_obtained_achieve"];
    }
    return _achieveImageView;
}

- (UILabel *)achieveBtnLabel
{
    if (!_achieveBtnLabel) {
        _achieveBtnLabel = [[UILabel alloc] init];
    }
    return _achieveBtnLabel;
}

@end
