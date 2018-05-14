//
//  WPGPlayRankCollectionViewCell.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/14.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGPlayRankCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>
#import "WPGPersonalCenterPage.h"

@implementation WPGPlayRankCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH-26, 65);
        self.backgroundColor = NF_Color_C1;
        _isSubGame = NO;
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    [self addSubview:self.rankLabel];
    [self addSubview:self.gameRankImageView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.scoreLabel];
    //[self addSubview:self.unitLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.badgeImageView];
    [self justFrame];
    self.userInteractionEnabled = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfile)];
    [self.avatarImageView addGestureRecognizer:gesture];
}

- (void)cellWithData:(WPGGamePageRanking *)rankModel RankNum:(NSInteger)rankNum;
{
    self.badgeImageView.hidden = YES;
    self.rankLabel.hidden = NO;
    self.avatarImageView.hidden = NO;
    self.gameRankImageView.hidden = NO;
    self.unitLabel.hidden = NO;
    self.scoreLabel.hidden = NO;
    self.nameLabel.hidden = NO;
    
    if (IS_NS_STRING_EMPTY(rankModel.winsPoint)) rankModel.winsPoint = @"0";
    if (IS_NS_STRING_EMPTY(rankModel.nickname)) rankModel.nickname = @" ";
    
    
    self.rankLabel.text = [NSString stringWithFormat:@"%@", @(rankNum)];
    UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *url = [NSURL URLWithString:rankModel.avatar];
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:defImg];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@", rankModel.winsPoint];
    self.nameLabel.text = rankModel.nickname;
    
    NSURL *url_level = [NSURL URLWithString:rankModel.winsLevel.icon];
    [self.gameRankImageView sd_setImageWithURL:url_level placeholderImage:defImg];
    [self justFrame];
    
    if (_isSubGame) {
        self.gameRankImageView.hidden = YES;
        self.badgeImageView.hidden = NO;
        self.badgeImageView.frame = CGRectMake(9, 19, 25, 29);
        if (rankNum == 1) self.badgeImageView.image = [UIImage imageNamed:@"ic_chart_medal1"];
        if (rankNum == 2) self.badgeImageView.image = [UIImage imageNamed:@"ic_chart_medal2"];
        if (rankNum == 3) self.badgeImageView.image = [UIImage imageNamed:@"ic_chart_medal3"];
        if (rankNum > 3) {
            self.badgeImageView.hidden = YES;
        }
    }
    _uid = [NSString stringWithFormat:@"%@", @(rankModel.uid)];
}

- (void)openProfile
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openAvatarProfile:WithUid:)]) {
        [self.delegate openAvatarProfile:self WithUid:_uid];
    }
}

- (void)justFrame
{
    CGFloat centerY = 65/2.0;
    self.rankLabel.frame = CGRectMake(15, 0, 0, 0);
    [self.rankLabel sizeToFit];
    self.rankLabel.centerY = centerY;
    
    self.avatarImageView.frame = CGRectMake(45, 0, 40, 40);
    self.avatarImageView.centerY = centerY;
    
    [self.scoreLabel sizeToFit];
    self.scoreLabel.frame = CGRectMake(self.frame.size.width-10-self.scoreLabel.contentSize.width, 0, self.scoreLabel.contentSize.width, self.scoreLabel.contentSize.height);
    self.scoreLabel.centerY = centerY;
    
    self.gameRankImageView.frame = CGRectMake(self.frame.size.width-74-27, 0, 27, 27);
    self.gameRankImageView.centerY = centerY;
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, 0, 0);
    [self.nameLabel sizeToFit];
    
    CGFloat nameLabelMaxWidth = CGRectGetMinX(self.gameRankImageView.frame) - CGRectGetMaxX(self.avatarImageView.frame) - 10 - 20;
    if (self.nameLabel.contentSize.width > nameLabelMaxWidth) {
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, nameLabelMaxWidth, self.nameLabel.contentSize.height);
    }
    self.nameLabel.centerY = centerY;
}

- (void)firstCell
{
    // 上半部有圆角，下半部没有圆角
    UIBezierPath *maskPathA = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayerA = [[CAShapeLayer alloc] init];
    maskLayerA.frame = self.bounds;
    maskLayerA.path = maskPathA.CGPath;
    self.layer.mask = maskLayerA;
    self.layer.masksToBounds = YES;
}

- (void)lastCell
{
    // 上半部没圆角，下半部有圆角
    UIBezierPath *maskPathA = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayerA = [[CAShapeLayer alloc] init];
    maskLayerA.frame = self.bounds;
    maskLayerA.path = maskPathA.CGPath;
    self.layer.mask = maskLayerA;
    self.layer.masksToBounds = YES;
}

- (void)midCell
{
    // 上半部有圆角，下半部没有圆角
    UIBezierPath *maskPathA = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft| UIRectCornerBottomRight cornerRadii:CGSizeMake(0, 0)];
    CAShapeLayer *maskLayerA = [[CAShapeLayer alloc] init];
    maskLayerA.frame = self.bounds;
    maskLayerA.path = maskPathA.CGPath;
    self.layer.mask = maskLayerA;
    self.layer.masksToBounds = YES;
}

- (void)noDataCell
{
    self.rankLabel.hidden = YES;
    self.avatarImageView.hidden = YES;
    self.gameRankImageView.hidden = YES;
    self.unitLabel.hidden = YES;
    self.scoreLabel.hidden = YES;
    self.nameLabel.hidden = YES;
    self.badgeImageView.hidden = YES;
}

- (UILabel *)rankLabel
{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.text = @"5";
        _rankLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _rankLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    }
    return _rankLabel;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        _avatarImageView.image = defImg;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @" ";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _nameLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UIImageView *)gameRankImageView
{
    if (!_gameRankImageView) {
        _gameRankImageView = [[UIImageView alloc] init];
        _gameRankImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gameRankImageView.layer.masksToBounds = YES;
    }
    return _gameRankImageView;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.text = @"0";
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

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(44, 65-1, self.frame.size.width-44, 1)];
        _lineView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#EFEFEF"];
    }
    return _lineView;
}

- (UIImageView *)badgeImageView
{
    if (!_badgeImageView) {
        _badgeImageView = [[UIImageView alloc] init];
        _badgeImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _badgeImageView;
}

@end
