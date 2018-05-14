//
//  WPGGiftBagWindowView.m
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGGiftBagWindowView.h"

#define ProportionWidth [UIScreen mainScreen].bounds.size.width/375
@interface WPGGiftBagWindowView ()

@end

@implementation WPGGiftBagWindowView


+(instancetype)checkInViewWithDynamicPopViewWithDiamindStr:(NSInteger)diamindStr{
    
    WPGGiftBagWindowView *checkInView = [[WPGGiftBagWindowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    checkInView.diamind = diamindStr;
    checkInView.diaminLabel.text = [NSString stringWithFormat:@"金币\n+%ld",diamindStr];
    return checkInView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self addSubview:self.backImage];

    [self.backImage addSubview:self.getPrizeView];
    
    [self.getPrizeView addSubview:self.titleImage];
    
    [self.getPrizeView addSubview:self.diaminLabel];
    
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backImage.mas_centerX);
        make.centerY.mas_equalTo(self.backImage.mas_centerY).with.offset(-(55+32+114*ProportionWidth));
    }];
    
    [self.diaminLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backImage.mas_centerX);
        make.centerY.mas_equalTo(self.backImage.mas_centerY).with.offset(55+40*ProportionWidth);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _rewardsPlayer = [self loadMusicWithName:@"questRewards" type:@"mp3"];//播放音效
    [_rewardsPlayer play];
    
    [self czh_showView];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(timerHideView:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

//4秒后自动关闭弹窗
- (void)timerHideView:(NSTimer *)timer{
    
    [timer invalidate];
    [self czh_hideView];
}

-(UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] init];
        _backImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _backImage.userInteractionEnabled = YES;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = _backImage.frame;
        [_backImage addSubview:effectView];
    }
    return _backImage;
}

- (WPGGetPrizeAnimationView *)getPrizeView
{
    if (nil != _getPrizeView) {
        return _getPrizeView;
    }
    _getPrizeView = [[WPGGetPrizeAnimationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) animationCode:11001 bAnimationCode:11002];
    _getPrizeView.midImgView.image = [UIImage imageNamed:@"img_block_seven_days_rewarded_items_upgrade_gift_box_big"];
    _getPrizeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *downTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(czh_hideView)];
      [_getPrizeView addGestureRecognizer:downTap];
    return _getPrizeView;
}

-(UIImageView *)titleImage{
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc] init];
        _titleImage.image = [UIImage imageNamed:@"img_rewards_text_title_rewarded"];
    }
    return _titleImage;
}

-(UILabel *)diaminLabel{
    if (!_diaminLabel) {
        _diaminLabel = [[UILabel alloc] init];
        _diaminLabel.font = [UIFont systemFontOfSize:18];
        _diaminLabel.textColor = [UIColor whiteColor];
        _diaminLabel.numberOfLines = 0;
    }
    return _diaminLabel;
}

//打开弹窗
- (void)czh_showView {
    [UIView animateWithDuration:0.3 animations:^{
//        _backImage.transform = CGAffineTransformMakeScale(1.0f, 1.0f);;
    } completion:nil];
}

//关闭弹窗
- (void)czh_hideView {
    [_rewardsPlayer stop];
    [UIView animateWithDuration:0.3 animations:^{
//        _backImage.transform = CGAffineTransformMakeScale(0.01f, 0.01f);;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


// 初始化音乐播放器
- (AVAudioPlayer *)loadMusicWithName:(NSString *)name type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:type];
    
    if (IS_NS_STRING_EMPTY(path)) {
        return nil;
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    [player setNumberOfLoops:0];
    
    [player prepareToPlay];
    
    return player;
}



@end
