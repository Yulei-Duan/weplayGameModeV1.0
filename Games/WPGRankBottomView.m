//
//  WPGRankBottomView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/14.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGRankBottomView.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>

@implementation WPGRankBottomView

- (void)dealloc
{
    IDSLOG("WPGRankBottomView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 65);
        self.backgroundColor = [UIColor whiteColor];
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    [self addSubview:self.rankLabel];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.levelImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.scoreLabel];
    [self addSubview:self.charmImageView];
    [self justFrame];
}

- (void)bottomViewWithData:(WPGGamePageMyRank *)rankModel;
{
    self.charmImageView.hidden = NO;
    self.levelImageView.hidden = NO;
    self.unitLabel.hidden = NO;
    self.rankLabel.hidden = NO;
    
    self.nameLabel.text = rankModel.nickname;
    self.scoreLabel.text = rankModel.winsPoint;
    NSInteger rankingNum = rankModel.ranking.integerValue;
    
    UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *url = [NSURL URLWithString:rankModel.avatar];
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:defImg];
    
    NSURL *url_level = [NSURL URLWithString:rankModel.winsLevel.icon];
    [self.levelImageView sd_setImageWithURL:url_level placeholderImage:defImg] ;
    
    if (rankingNum == 1) {
        self.charmImageView.image = IDSImageNamed(@"ic_chart_medal1");
    }
    if (rankingNum == 2) {
        self.charmImageView.image = IDSImageNamed(@"ic_chart_medal2");
    }
    if (rankingNum == 3) {
        self.charmImageView.image = IDSImageNamed(@"ic_chart_medal3");
    }
    if (rankingNum > 3 || rankingNum < 1) {
        self.charmImageView.hidden = YES;
        self.rankLabel.hidden = NO;
    }
    else {
        self.rankLabel.hidden = YES;
    }
    
    if (rankingNum <= 0) {
        self.rankLabel.text = @"--";
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
    }
    else if (rankingNum <=3 ) {
        self.rankLabel.text = rankModel.ranking;
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:23];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
        
        self.unitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        self.unitLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
    }
    else {
        self.rankLabel.text = rankModel.ranking;
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
        
        self.unitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        self.unitLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
    }
    [self justFrame];
}

- (void)bottomViewWithSubGameData:(WPGGamePageMyRank *)rankModel
{
    self.charmImageView.hidden = NO;
    self.levelImageView.hidden = YES;
    self.photoFrameView.hidden = YES;
    
    self.nameLabel.text = rankModel.nickname;
    self.scoreLabel.text = rankModel.winsPoint;
    NSInteger rankingNum = rankModel.ranking.integerValue;
    
    UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *url = [NSURL URLWithString:rankModel.avatar];
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:defImg];

    if (rankingNum == 1|rankingNum == 2|rankingNum == 3) {
        self.charmImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_chart_medal%@", @(rankingNum)]];
    }
    
    if (rankingNum > 3 || rankingNum < 1) {
        self.charmImageView.hidden = YES;
        self.rankLabel.hidden = NO;
    }
    else {
        self.rankLabel.hidden = YES;
    }
    
    if (rankingNum <= 0) {
        self.rankLabel.text = @"--";
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
    }
    else if (rankingNum <=3 ) {
        self.rankLabel.text = rankModel.ranking;
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:23];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
        
        self.unitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        self.unitLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
    }
    else {
        self.rankLabel.text = rankModel.ranking;
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
        
        self.unitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        self.unitLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
    }
    [self justSubGameFrame];
}

- (void)bottomViewWithCharmData:(WPGCharmMyRank *)rankModel
{
    self.charmImageView.hidden = NO;
    self.levelImageView.hidden = YES;
    self.unitLabel.hidden = YES;
    self.photoFrameView.hidden = YES;
    
    //rankModel.ranking = @"2";
    self.nameLabel.text = rankModel.nickname;
    self.scoreLabel.text = [NSString stringWithFormat:@"魅力值:%@",rankModel.charm];
    NSInteger rankingNum = rankModel.ranking.integerValue;
    
    UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *url = [NSURL URLWithString:rankModel.avatar];
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:defImg];
    
    if (rankingNum == 1|rankingNum == 2|rankingNum == 3) {
        self.charmImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_chart_medal%@", @(rankingNum)]];
    }
    if (rankingNum > 3 || rankingNum < 1) {
        self.charmImageView.hidden = YES;
        self.rankLabel.hidden = NO;
    }
    else {
        self.rankLabel.hidden = YES;
    }
    
    if (rankingNum <= 0) {
        self.rankLabel.text = @"--";
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
    }
    else if (rankingNum <=3 ) {
        self.rankLabel.text = rankModel.ranking;
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:23];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
        
        self.unitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        self.unitLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FF3D34"];
    }
    else {
        self.rankLabel.text = rankModel.ranking;
        self.rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        self.rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
        
        self.scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
        
        self.unitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        self.unitLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
    }
    [self justCharmFrame];
}

- (void)justFrame
{
    CGFloat centerY = 65 / 2.0;
    self.rankLabel.frame = CGRectMake(12, 0, 0, 0);
    [self.rankLabel sizeToFit];
    self.rankLabel.centerY = centerY;
    self.rankLabel.centerX = 57 / 2.0;
    
    self.avatarImageView.frame = CGRectMake(57, 0, 40, 40);
    self.avatarImageView.centerY = centerY;
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, 0, 0);
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = centerY;
    
    [self.scoreLabel sizeToFit];
    self.scoreLabel.frame = CGRectMake(SCREEN_WIDTH-self.scoreLabel.contentSize.width-27, 0, self.scoreLabel.contentSize.width, self.scoreLabel.contentSize.height);
    self.scoreLabel.centerY = centerY;
    
    self.levelImageView.frame = CGRectMake(CGRectGetMinX(self.scoreLabel.frame)-5-28, 0, 28, 22);
    self.levelImageView.centerY = centerY;
    
    CGFloat nameLabelMaxWidth = CGRectGetMinX(self.levelImageView.frame) - CGRectGetMaxX(self.avatarImageView.frame) - 10 - 20;
    if (self.nameLabel.contentSize.width > nameLabelMaxWidth) {
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, nameLabelMaxWidth, self.nameLabel.contentSize.height);
        self.nameLabel.centerY = centerY;
    }
    
    self.unitLabel.frame = CGRectMake(SCREEN_WIDTH-17-13-self.unitLabel.contentSize.width, CGRectGetMaxY(self.scoreLabel.frame)-self.unitLabel.contentSize.height-1, self.unitLabel.contentSize.width, self.unitLabel.contentSize.height);
}

- (void)justCharmFrame
{
    CGFloat centerY = 65 / 2.0;
    self.rankLabel.frame = CGRectMake(12, 0, 0, 0);
    [self.rankLabel sizeToFit];
    self.rankLabel.centerY = centerY;
    self.rankLabel.centerX = 57 / 2.0;
    
    self.avatarImageView.frame = CGRectMake(57, 0, 40, 40);
    self.avatarImageView.centerY = centerY;
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, 0, 0);
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = centerY;
    
    [self.unitLabel sizeToFit];
    self.unitLabel.frame = CGRectMake(SCREEN_WIDTH-17-13-self.unitLabel.contentSize.width, 0, self.unitLabel.contentSize.width, self.unitLabel.contentSize.height);
    
    
    [self.scoreLabel sizeToFit];
    self.scoreLabel.frame = CGRectMake(SCREEN_WIDTH-self.scoreLabel.contentSize.width-27, 0, self.scoreLabel.contentSize.width, self.scoreLabel.contentSize.height);
    self.scoreLabel.centerY = centerY;

    CGFloat nameLabelMaxWidth = CGRectGetMinX(self.scoreLabel.frame) - CGRectGetMaxX(self.avatarImageView.frame) - 10 - 20;
    if (self.nameLabel.contentSize.width > nameLabelMaxWidth) {
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, nameLabelMaxWidth, self.nameLabel.contentSize.height);
        self.nameLabel.centerY = centerY;
    }
}

- (void)justSubGameFrame
{
    CGFloat centerY = 65 / 2.0;
    self.rankLabel.frame = CGRectMake(12, 0, 0, 0);
    [self.rankLabel sizeToFit];
    self.rankLabel.centerY = centerY;
    self.rankLabel.centerX = 57 / 2.0;
    
    self.avatarImageView.frame = CGRectMake(57, 0, 40, 40);
    self.avatarImageView.centerY = centerY;
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, 0, 0);
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = centerY;
    
    [self.unitLabel sizeToFit];
    self.unitLabel.frame = CGRectMake(SCREEN_WIDTH-17-13-self.unitLabel.contentSize.width, 0, self.unitLabel.contentSize.width, self.unitLabel.contentSize.height);
    
    
    [self.scoreLabel sizeToFit];
    self.scoreLabel.frame = CGRectMake(CGRectGetMinX(self.unitLabel.frame)-1-self.scoreLabel.contentSize.width, 0, self.scoreLabel.contentSize.width, self.scoreLabel.contentSize.height);
    self.scoreLabel.centerY = centerY;
    
    self.levelImageView.frame = CGRectMake(CGRectGetMinX(self.scoreLabel.frame)-5-28, 0, 28, 22);
    self.levelImageView.centerY = centerY;
    
    CGFloat nameLabelMaxWidth = CGRectGetMinX(self.levelImageView.frame) - CGRectGetMaxX(self.avatarImageView.frame) - 10 - 20;
    if (self.nameLabel.contentSize.width > nameLabelMaxWidth) {
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, nameLabelMaxWidth, self.nameLabel.contentSize.height);
        self.nameLabel.centerY = centerY;
    }
    
    self.unitLabel.frame = CGRectMake(SCREEN_WIDTH-17-13-self.unitLabel.contentSize.width, CGRectGetMaxY(self.scoreLabel.frame)-self.unitLabel.contentSize.height-1, self.unitLabel.contentSize.width, self.unitLabel.contentSize.height);
}

- (UILabel *)rankLabel
{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.text = @"--";
        _rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
    }
    return _rankLabel;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        _avatarImageView.image = defImg;
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)levelImageView
{
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc] init];
        _levelImageView.contentMode = UIViewContentModeScaleAspectFill;
        _levelImageView.image = IDSImageNamed(@"ic_chart_badge1");
    }
    return _levelImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"你叫什么名字呀亲亲亲亲亲亲亲亲亲亲亲亲亲亲亲亲亲亲";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _nameLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.text = @"9209";
        _scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
    }
    return _scoreLabel;
}

- (UILabel *)unitLabel
{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.text = @"分";
        _unitLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        _unitLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
        [_unitLabel sizeToFit];
    }
    return _unitLabel;
}

- (UIImageView *)photoFrameView
{
    if (!_photoFrameView) {
        _photoFrameView = [[UIImageView alloc] init];
        _photoFrameView.frame = CGRectMake(53.5, -2.9, 51, 59);
        _photoFrameView.image = [UIImage imageNamed:@"ic_chart_crown1"];
        _photoFrameView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoFrameView;
}

- (UIImageView *)charmImageView
{
    if (!_charmImageView) {
        _charmImageView = [[UIImageView alloc] init];
        _charmImageView.frame = CGRectMake(14, 21, 25, 29);
        _charmImageView.image = [UIImage imageNamed:@"ic_chart_medal1"];
        _charmImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _charmImageView;
}

@end
