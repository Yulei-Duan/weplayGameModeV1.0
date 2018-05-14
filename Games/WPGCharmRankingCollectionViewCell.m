//
//  WPGCharmRankingCollectionViewCell.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/15.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGCharmRankingCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>

@implementation WPGCharmRankingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [ColorUtil cl_colorWithHexString:@"#F7F6FB"];;
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    [self addSubview:self.coverImageView];
    [self addSubview:self.fadeAlphaView];
    [self addSubview:self.badgeImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.charmLabel];
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)cellWithData:(WPGCharmRankSubModel *)rankModel RankNum:(NSInteger)rankNum
{
    if (!rankModel) {
        return;
    }
    ++rankNum;
    
    if (rankNum>3 || rankNum < 1) {
        self.badgeImageView.hidden = YES;
    }
    else {
        self.badgeImageView.hidden = NO;
    }
    
    if (!rankModel.nickname) rankModel.nickname = @"未命名";
    if (!rankModel.charm) rankModel.charm = 0;
    
    //UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *url = [NSURL URLWithString:rankModel.avatar];
    [self.coverImageView sd_setImageWithURL:url placeholderImage:nil];
    CGFloat maxLabelLength = 0;
    if (rankNum == 1) {
        maxLabelLength = SCREEN_WIDTH-28-54;
        
        self.fadeAlphaView.frame = CGRectMake(0, SCREEN_WIDTH-60, SCREEN_WIDTH, 60);
        [self changeAlpha];
        
        self.coverImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        self.badgeImageView.frame = CGRectMake(10, SCREEN_WIDTH-48, 32, 38);
        self.badgeImageView.image = IDSImageNamed(@"ic_chart_medal1_big");
        
        self.nameLabel.frame = CGRectMake(14+CGRectGetMaxX(self.badgeImageView.frame), CGRectGetMinY(self.badgeImageView.frame)-2, 0, 0);
        self.nameLabel.text = rankModel.nickname;
        self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [self.nameLabel sizeToFit];
        
        self.charmLabel.frame = CGRectMake(14+CGRectGetMaxX(self.badgeImageView.frame), CGRectGetMaxY(self.nameLabel.frame), 0, 0);
        self.charmLabel.text = [NSString stringWithFormat:@"魅力值：%@", rankModel.charm];
        self.charmLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [self.charmLabel sizeToFit];
        
        if (self.nameLabel.contentSize.width > maxLabelLength) {
            self.nameLabel.frame = CGRectMake(14+CGRectGetMaxX(self.badgeImageView.frame)-2, 40, maxLabelLength, self.nameLabel.contentSize.height);
        }
        if (self.charmLabel.contentSize.width > maxLabelLength) {
            self.charmLabel.frame = CGRectMake(14+CGRectGetMaxX(self.badgeImageView.frame), CGRectGetMaxY(self.nameLabel.frame), maxLabelLength, self.charmLabel.contentSize.height);
        }
    }
    if (rankNum == 2 || rankNum == 3) {
        maxLabelLength = SCREEN_WIDTH/2.0-28-43;
        
        self.fadeAlphaView.frame = CGRectMake(0, SCREEN_WIDTH/2.0-50, SCREEN_WIDTH/2.0, 50);
        [self changeAlpha];
        
        self.coverImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0);
        self.badgeImageView.frame = CGRectMake(10, SCREEN_WIDTH/2.0-10-29, 25, 29);
        
        if (rankNum == 2) self.badgeImageView.image = IDSImageNamed(@"ic_chart_medal2");
        if (rankNum == 3) self.badgeImageView.image = IDSImageNamed(@"ic_chart_medal3");
        
        self.nameLabel.frame = CGRectMake(14+CGRectGetMaxX(self.badgeImageView.frame), CGRectGetMinY(self.badgeImageView.frame)-2, 0, 0);
        self.nameLabel.text = rankModel.nickname;
        self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [self.nameLabel sizeToFit];
        
        self.charmLabel.frame = CGRectMake(14+CGRectGetMaxX(self.badgeImageView.frame), CGRectGetMaxY(self.nameLabel.frame), 0, 0);
        self.charmLabel.text = [NSString stringWithFormat:@"魅力值：%@", rankModel.charm];
        self.charmLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        [self.charmLabel sizeToFit];
        
        if (self.nameLabel.contentSize.width > maxLabelLength) {
            self.nameLabel.frame = CGRectMake(14+CGRectGetMaxX(self.badgeImageView.frame), CGRectGetMinY(self.badgeImageView.frame)-2, maxLabelLength, self.nameLabel.contentSize.height);
        }
        if (self.charmLabel.contentSize.width > maxLabelLength) {
            self.charmLabel.frame = CGRectMake(14+CGRectGetMaxX(self.badgeImageView.frame), CGRectGetMaxY(self.nameLabel.frame), maxLabelLength, self.charmLabel.contentSize.height);
        }
    }
    if (rankNum > 3) {
        maxLabelLength = SCREEN_WIDTH/3.0-28-5;
        
        self.fadeAlphaView.frame = CGRectMake(0, SCREEN_WIDTH/3.0-50, SCREEN_WIDTH/3.0, 50);
        [self changeAlpha];
        
        self.coverImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH/3.0, SCREEN_WIDTH/3.0);
        self.nameLabel.frame = CGRectMake(5, SCREEN_WIDTH/3.0-42, 0, 0);
        self.nameLabel.text = [NSString stringWithFormat:@"%@.%@",@(rankNum),rankModel.nickname];
        self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [self.nameLabel sizeToFit];
        
        self.charmLabel.frame = CGRectMake(5, CGRectGetMaxY(self.nameLabel.frame), 0, 0);
        self.charmLabel.text = [NSString stringWithFormat:@"魅力值：%@", rankModel.charm];
        self.charmLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        [self.charmLabel sizeToFit];
        
        if (self.nameLabel.contentSize.width > maxLabelLength) {
            self.nameLabel.frame = CGRectMake(5, SCREEN_WIDTH/3.0-42, maxLabelLength, self.nameLabel.contentSize.height);
        }
        if (self.charmLabel.contentSize.width > maxLabelLength) {
            self.charmLabel.frame = CGRectMake(5, CGRectGetMaxY(self.nameLabel.frame), maxLabelLength, self.charmLabel.contentSize.height);
        }
        
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.clipsToBounds = YES;
        self.fadeAlphaView.layer.masksToBounds = YES;
        self.fadeAlphaView.clipsToBounds = YES;
    }
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        CGFloat red = arc4random()/(0xffffffff*1.0);
        CGFloat green = arc4random()/(0xffffffff*1.0);
        CGFloat blue = arc4random()/(0xffffffff*1.0);
        UIColor *myColer = [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
        
        _coverImageView.backgroundColor = myColer;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

- (UIImageView *)badgeImageView
{
    if (!_badgeImageView) {
        _badgeImageView = [[UIImageView alloc] init];
        _badgeImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _badgeImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
    }
    return _nameLabel;
}

- (UILabel *)charmLabel
{
    if (!_charmLabel) {
        _charmLabel = [[UILabel alloc] init];
        _charmLabel.text = @"魅力值：0万";
        _charmLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
    }
    return _charmLabel;
}

- (UIView *)fadeAlphaView
{
    if (!_fadeAlphaView) {
        _fadeAlphaView = [[UIView alloc] init];
        _fadeAlphaView.backgroundColor = [UIColor blackColor];
        _fadeAlphaView.layer.masksToBounds = YES;
        _fadeAlphaView.clipsToBounds = YES;
    }
    return _fadeAlphaView;
}

-(void)changeAlpha
{
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       nil];
    [gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
    [gradLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
    [gradLayer setFrame:self.fadeAlphaView.bounds];
    [self.fadeAlphaView.layer setMask:gradLayer];
}

@end
