//
//  WPGGameCollectionViewCell.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/12.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGGameCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>

@implementation WPGGameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        [self addSubview:self.backgroundImageview];
        [self.backgroundImageview addSubview:self.nameTitleLabel];
        [self.backgroundImageview addSubview:self.playerCountLabel];
        [self.backgroundImageview addSubview:self.levelImageView];
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH-30, 100);
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)cellWithData:(WPGGamePageGames *)gameModel
{
    if (!gameModel) {
        return;
    }
    self.levelImageView.hidden = YES;
    UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *url = [NSURL URLWithString:gameModel.cover];
    [self.backgroundImageview sd_setImageWithURL:url placeholderImage:nil];
    NSURL *url_level = [NSURL URLWithString:gameModel.levelIcon];
    [self.levelImageView sd_setImageWithURL:url_level placeholderImage:defImg];
    
    self.nameTitleLabel.text = [StringUtil trim:gameModel.name];
    [self.nameTitleLabel sizeToFit];
    self.playerCountLabel.text = [NSString stringWithFormat:@"%@对在玩", [StringUtil trim:gameModel.number]];
    [self.playerCountLabel sizeToFit];
    
    if (gameModel.type == 0) {
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH-30, 100);
        _alphaImageview.image = [UIImage imageNamed:@"img_game_cover_s1"];
        if (self.nameTitleLabel.contentSize.width > SCREEN_WIDTH-50) {
            self.nameTitleLabel.frame = CGRectMake(10, 47, SCREEN_WIDTH-50, self.nameTitleLabel.contentSize.height);
        }
        if (self.playerCountLabel.contentSize.width > SCREEN_WIDTH-50) {
            self.playerCountLabel.frame = CGRectMake(10, 75, SCREEN_WIDTH-50, self.playerCountLabel.contentSize.height);
        }
    }
    else {
        self.bounds = CGRectMake(0, 0, (SCREEN_WIDTH-40)/2.0, 100);
        _alphaImageview.image = [UIImage imageNamed:@"img_game_cover_s"];
        if (self.nameTitleLabel.contentSize.width > (SCREEN_WIDTH-40)/2.0-20) {
            self.nameTitleLabel.frame = CGRectMake(10, 47, (SCREEN_WIDTH-40)/2.0-20, self.nameTitleLabel.contentSize.height);
        }
        if (self.playerCountLabel.contentSize.width > (SCREEN_WIDTH-40)/2.0-20) {
            self.playerCountLabel.frame = CGRectMake(10, 75, (SCREEN_WIDTH-40)/2.0-20, self.playerCountLabel.contentSize.height);
        }
    }
    _backgroundImageview.frame = self.bounds;
    _alphaImageview.frame = _backgroundImageview.frame;
    self.levelImageView.frame = CGRectMake(self.bounds.size.width-10-35, 0, 35, 38);
}

- (UIImageView *)backgroundImageview
{
    if (!_backgroundImageview) {
        _backgroundImageview = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageview.layer.cornerRadius = 6.f;
        _backgroundImageview.layer.masksToBounds = YES;
        _backgroundImageview.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat red = arc4random()/(0xffffffff*1.0);
        CGFloat green = arc4random()/(0xffffffff*1.0);
        CGFloat blue = arc4random()/(0xffffffff*1.0);
        UIColor *myColer = [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
        _backgroundImageview.backgroundColor = myColer;
        _alphaImageview = [[UIImageView alloc] initWithFrame:_backgroundImageview.frame];
        _alphaImageview.contentMode = UIViewContentModeScaleAspectFill;
        _alphaImageview.image = [UIImage imageNamed:@"img_game_cover_s"];
        _backgroundImageview.layer.masksToBounds = YES;
        [_backgroundImageview addSubview:_alphaImageview];
    }
    return _backgroundImageview;
}

- (UILabel *)nameTitleLabel
{
    if (!_nameTitleLabel) {
        _nameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 47, 206, 25)];
        _nameTitleLabel.text = @" ";
        _nameTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        _nameTitleLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _nameTitleLabel;
}

- (UILabel *)playerCountLabel
{
    if (!_playerCountLabel) {
        _playerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 0, 0)];
        _playerCountLabel.text = @" ";
        [_playerCountLabel sizeToFit];
        _playerCountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _playerCountLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.8];
    }
    return _playerCountLabel;
}

- (UIImageView *)levelImageView
{
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 38)];
        _levelImageView.contentMode = UIViewContentModeScaleAspectFill;
        _levelImageView.layer.masksToBounds = YES;
    }
    return _levelImageView;
}

@end
