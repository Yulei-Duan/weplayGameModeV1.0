//
//  WPGPersonalCenterCollectionViewCell.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGPersonalCenterCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>

@implementation WPGPersonalCenterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [ColorUtil cl_colorWithHexString:@"#F7F6FB"];;
        [self addUIView];
    }
    return self;
}

- (void)addUIView
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.coverImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.newImageView];
    [self adjustViewFrame];
}

- (void)cellWithData:(WPGAchieveMentListModel *)achievementModel
{
    if (!achievementModel) {
        return;
    }
    if (IS_NS_STRING_EMPTY(achievementModel.giftName)) achievementModel.giftName = @" ";
    
    UIImage *defImg = [IDSImageManager defaultAvatar:SquareStyle];
    NSURL *avatar_url = [NSURL URLWithString:achievementModel.iconUrl];
    [self.coverImageView sd_setImageWithURL:avatar_url placeholderImage:defImg];
    self.titleLabel.text = achievementModel.name;
    if (achievementModel.status == 0) {
        // 未解锁
        self.newImageView.hidden = YES;
        self.titleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
    }
    else if (achievementModel.status == 1) {
        // 已解锁 未领取
        self.newImageView.hidden = NO;
        self.titleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    }
    else {
        // 已解锁 已领取
        self.newImageView.hidden = YES;
        self.titleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    }
    [self adjustViewFrame];
}

- (void)adjustViewFrame
{
    //self.frame = CGRectMake(0, 0, 111, 136);
    CGFloat centerX = self.frame.size.width / 2.0;
    self.coverImageView.frame = CGRectMake(0, 13, 79, 88);
    self.coverImageView.centerX = centerX;
    
    self.titleLabel.frame = CGRectMake(0, 107, 0, 0);
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = centerX;
    
    self.newImageView.frame = CGRectMake(CGRectGetMinX(self.coverImageView.frame)+50, CGRectGetMinY(self.coverImageView.frame)+2, 34, 17);
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 111, 136)];
        _backgroundImageView.image = [UIImage imageNamed:@"img_personal_base"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 88)];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UIImageView *)newImageView
{
    if (!_newImageView) {
        _newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 17)];
        _newImageView.image = [UIImage imageNamed:@"ic_personal_new"];
        _newImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _newImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"第一桶金";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _titleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    }
    return _titleLabel;
}

@end
