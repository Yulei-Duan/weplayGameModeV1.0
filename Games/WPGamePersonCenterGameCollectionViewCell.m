//
//  WPGamePersonCenterGameCollectionViewCell.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGamePersonCenterGameCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>

@implementation WPGamePersonCenterGameCollectionViewCell


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
    [self addSubview:self.gameImageView];
    [self addSubview:self.alphaView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.levelImageView];
    [self adjustViewFrame];
}

- (void)loadDataWithModel:(WPGameListModel *)gameModel
{
    self.levelImageView.hidden = YES;
    if (!gameModel) {
        return;
    }
    
    if (IS_NS_STRING_EMPTY(gameModel.name)) gameModel.name = @" ";

    UIImage *defImg = [IDSImageManager defaultAvatar:SquareStyle];
    NSURL *avatar_url = [NSURL URLWithString:gameModel.cover];
    [self.gameImageView sd_setImageWithURL:avatar_url placeholderImage:defImg];
    
    NSURL *level_url = [NSURL URLWithString:gameModel.levelIcon];
    [self.levelImageView sd_setImageWithURL:level_url placeholderImage:defImg];

    self.nameLabel.text = [StringUtil trim:gameModel.name];
    [self adjustViewFrame];
}

- (void)adjustViewFrame
{
    
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
    self.gameImageView.frame = CGRectMake(0, 0, 75, 75);
    self.alphaView.frame = CGRectMake(0, 0, 75, 75);
    self.nameLabel.frame = CGRectMake(5, 54, 0, 0);
    [self.nameLabel sizeToFit];
    if (self.nameLabel.contentSize.width > 70) {
        self.nameLabel.frame = CGRectMake(5, 54, 70, self.nameLabel.contentSize.height);
    }
}

- (UIImageView *)gameImageView
{
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        CGFloat red = arc4random()/(0xffffffff*1.0);
        CGFloat green = arc4random()/(0xffffffff*1.0);
        CGFloat blue = arc4random()/(0xffffffff*1.0);
        UIColor *myColer = [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
        _gameImageView.backgroundColor = myColer;
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gameImageView.layer.cornerRadius = 10.f;
        _gameImageView.layer.masksToBounds = YES;
    }
    return _gameImageView;
}

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] init];
        _alphaView.frame = CGRectMake(0, 0, 75, 75);
        _alphaView.backgroundColor = [UIColor blackColor];
        CAGradientLayer *gradLayer = [CAGradientLayer layer];
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                           (id)[[UIColor colorWithWhite:0 alpha:0.4] CGColor],
                           (id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor],
                           nil];
        [gradLayer setColors:colors];
        //渐变起止点，point表示向量
        [gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
        [gradLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
        [gradLayer setFrame:_alphaView.bounds];
        [_alphaView.layer setMask:gradLayer];
    }
    return _alphaView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @" ";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:11];
        _nameLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
    }
    return _nameLabel;
}

- (UILabel *)gameNumLabel
{
    if (!_gameNumLabel) {
        _gameNumLabel = [[UILabel alloc] init];
        _gameNumLabel.text = @"0对在玩";
        _gameNumLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:9];
        _gameNumLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
        _gameNumLabel.alpha = 0.8f;
    }
    return _gameNumLabel;
}

- (UIImageView *)levelImageView
{
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 0, 21, 22)];
        _levelImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _levelImageView;
}

@end
