//
//  WPGGameRankHeaderView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/14.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGGameRankHeaderView.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>

@interface WPGGameRankHeaderView()

// 背景阶梯层，在背景透明层上方
@property (nonatomic, strong) UIImageView *floorLayerImageView;
// 左侧头像框
@property (nonatomic, strong) UIImageView *leftPictureFrame;
// 中间头像框
@property (nonatomic, strong) UIImageView *midPictureFrame;
// 右侧头像框
@property (nonatomic, strong) UIImageView *rightPictureFrame;
// 左侧头像
@property (nonatomic, strong) UIImageView *leftAvatarImageView;
// 中间头像
@property (nonatomic, strong) UIImageView *midAvatarImageView;
// 右侧头像
@property (nonatomic, strong) UIImageView *rightAvatarImageView;
// 左侧人物名称
@property (nonatomic, strong) UILabel *leftAvatarNameLabel;
// 中侧人物名称
@property (nonatomic, strong) UILabel *midAvatarNameLabel;
// 右侧人物名称
@property (nonatomic, strong) UILabel *rightAvatarNameLabel;
// 左侧人物分数
@property (nonatomic, strong) UILabel *leftAvatarScoreLabel;
// 中侧人物分数
@property (nonatomic, strong) UILabel *midAvatarScoreLabel;
// 右侧人物分数
@property (nonatomic, strong) UILabel *rightAvatarScoreLabel;
// 左侧人物徽章
@property (nonatomic, strong) UIImageView *leftBadgesImage;
// 中侧人物徽章
@property (nonatomic, strong) UIImageView *midBadgesImage;
// 右侧人物徽章
@property (nonatomic, strong) UIImageView *rightBadgesImage;

@property (nonatomic, strong) UITapGestureRecognizer *recognizerA1;

@property (nonatomic, strong) UITapGestureRecognizer *recognizerA2;

@property (nonatomic, strong) UITapGestureRecognizer *recognizerA3;

@property (nonatomic, copy) NSString *uidA1;
@property (nonatomic, copy) NSString *uidA2;
@property (nonatomic, copy) NSString *uidA3;

@end

@implementation WPGGameRankHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    // 增加阶梯的图片层
    [self addSubview:self.floorLayerImageView];
    // 670 *195  97
    self.floorLayerImageView.frame = CGRectMake(15, 245-98-64, SCREEN_WIDTH-30, 98);
    
    // 第一个台阶的中心X坐标
    float centerX_A = 15 + 57.5/ 345.0  * (SCREEN_WIDTH - 30.0);
    // 第二个台阶的中心X坐标
    float centerX_B = SCREEN_WIDTH / 2.0;
    // 第三个台阶的中心X坐标
    float centerX_C = SCREEN_WIDTH - centerX_A;
    
    // 头像贴在阶梯层
    [self.leftPictureFrame addSubview:self.leftAvatarImageView];
    self.leftAvatarImageView.frame = CGRectMake(45, 47, 54, 54);
    
    [self.midPictureFrame addSubview:self.midAvatarImageView];
    self.midAvatarImageView.frame = CGRectMake(23, 31, 69, 69);
    
    [self.rightPictureFrame addSubview:self.rightAvatarImageView];
    self.rightAvatarImageView.frame = CGRectMake(31, 47, 54, 54);
    
    self.leftPictureFrame.userInteractionEnabled = YES;
    self.midPictureFrame.userInteractionEnabled = YES;
    self.rightPictureFrame.userInteractionEnabled = YES;
    
    // 头像框贴在头像上面
    [self addSubview:self.leftPictureFrame];
    self.leftPictureFrame.frame = CGRectMake(0, 73+13-64, 115, 115);
    self.leftPictureFrame.centerX = centerX_A;
    
    [self addSubview:self.midPictureFrame];
    self.midPictureFrame.frame = CGRectMake(0, 63-64, 115, 115);
    self.midPictureFrame.centerX = centerX_B;
    
    [self addSubview:self.rightPictureFrame];
    self.rightPictureFrame.frame = CGRectMake(0, 73+13-64, 115, 115);
    self.rightPictureFrame.centerX = centerX_C;
    
    UIImageView *imageView_leftLayer = [[UIImageView alloc] initWithFrame:CGRectMake(78, 102, 29, 11)];
    imageView_leftLayer.image = [UIImage imageNamed:@"img_ranking_shadow2"];
    [self.leftPictureFrame addSubview:imageView_leftLayer];
    
    UIImageView *imageView_midLayer = [[UIImageView alloc] initWithFrame:CGRectMake(74, 102, 29, 11)];
    imageView_midLayer.image = [UIImage imageNamed:@"img_ranking_shadow1"];
    [self.midPictureFrame addSubview:imageView_midLayer];
    
    UIImageView *imageView_rightLayer = [[UIImageView alloc] initWithFrame:CGRectMake(73, 102, 29, 11)];
    imageView_rightLayer.image = [UIImage imageNamed:@"img_ranking_shadow3"];
    [self.rightPictureFrame addSubview:imageView_rightLayer];
    
    
    [self.leftPictureFrame addSubview:self.leftBadgesImage];
    [self.midPictureFrame addSubview:self.midBadgesImage];
    [self.rightPictureFrame addSubview:self.rightBadgesImage];
    self.leftBadgesImage.frame = CGRectMake(79, 85, 27, 27);
    self.midBadgesImage.frame = CGRectMake(75, 86, 27, 27);
    self.rightBadgesImage.frame = CGRectMake(74, 85, 27, 27);
    
    // 用户名称贴在头像框栏上
    [self addSubview:self.leftAvatarNameLabel];
    [self addSubview:self.midAvatarNameLabel];
    [self addSubview:self.rightAvatarNameLabel];
    
    // 用户分数贴在阶梯上
    [self addSubview:self.leftAvatarScoreLabel];
    [self addSubview:self.midAvatarScoreLabel];
    [self addSubview:self.rightAvatarScoreLabel];
    
    _recognizerA1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfile:)];
    _recognizerA2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfile:)];
    _recognizerA3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfile:)];
    [self.leftAvatarImageView addGestureRecognizer:_recognizerA1];
    [self.midAvatarImageView addGestureRecognizer:_recognizerA2];
    [self.rightAvatarImageView addGestureRecognizer:_recognizerA3];
    self.leftAvatarImageView.userInteractionEnabled = YES;
    self.midAvatarImageView.userInteractionEnabled = YES;
    self.rightAvatarImageView.userInteractionEnabled = YES;
    
    [self justFrame];
}

- (void)justFrame
{
    // 第一个台阶的中心X坐标
    float centerX_A = 15 + 57.5/ 345.0  * (SCREEN_WIDTH - 30.0);
    // 第二个台阶的中心X坐标
    float centerX_B = SCREEN_WIDTH / 2.0;
    // 第三个台阶的中心X坐标
    float centerX_C = SCREEN_WIDTH - centerX_A;
    
    self.leftAvatarNameLabel.frame = CGRectMake(0, 133+73-64, 0, 0);
    [self.leftAvatarNameLabel sizeToFit];
    if (self.leftAvatarNameLabel.contentSize.width > 100) {
        self.leftAvatarNameLabel.frame = CGRectMake(0, 133+73-64, 100,  self.leftAvatarNameLabel.contentSize.height);
    }
    self.leftAvatarNameLabel.centerX = centerX_A;
    
    self.midAvatarNameLabel.frame = CGRectMake(0, 112+73-64, 0, 0);
    [self.midAvatarNameLabel sizeToFit];
    if (self.midAvatarNameLabel.contentSize.width > 100) {
        self.midAvatarNameLabel.frame = CGRectMake(0, 112+73-64, 100,  self.midAvatarNameLabel.contentSize.height);
    }
    self.midAvatarNameLabel.centerX = centerX_B;
    
    self.rightAvatarNameLabel.frame = CGRectMake(0, 133+73-64, 0, 0);
    [self.rightAvatarNameLabel sizeToFit];
    if (self.rightAvatarNameLabel.contentSize.width > 100) {
        self.rightAvatarNameLabel.frame = CGRectMake(0, 133+73-64, 100,  self.rightAvatarNameLabel.contentSize.height);
    }
    self.rightAvatarNameLabel.centerX = centerX_C;
    
    self.leftAvatarScoreLabel.frame = CGRectMake(0, 152+73-64, 0, 0);
    [self.leftAvatarScoreLabel sizeToFit];
    self.leftAvatarScoreLabel.centerX = centerX_A;
    
    self.midAvatarScoreLabel.frame = CGRectMake(0, 132+73-64, 0, 0);
    [self.midAvatarScoreLabel sizeToFit];
    self.midAvatarScoreLabel.centerX = centerX_B;
    
    self.rightAvatarScoreLabel.frame = CGRectMake(0, 152+73-64, 0, 0);
    [self.rightAvatarScoreLabel sizeToFit];
    self.rightAvatarScoreLabel.centerX = centerX_C;
}

- (void)openProfile:(UITapGestureRecognizer *)tapGesture
{
    NSString *uid;
    if (tapGesture == _recognizerA1) uid = _uidA1;
    if (tapGesture == _recognizerA2) uid = _uidA2;
    if (tapGesture == _recognizerA3) uid = _uidA3;
    if (self.delegate && [self.delegate respondsToSelector:@selector(openAvatarProfile:withUid:)]) {
        [self.delegate openAvatarProfile:self withUid:uid];
    }
}

- (void)addDataWithArray:(NSArray<WPGGamePageRanking *> *)rankArray
{
    if (!rankArray || rankArray.count < 3) {
        return;
    }
    
    NSArray *array = [rankArray subarrayWithRange:NSMakeRange(0, 3)];
    
    WPGGamePageRanking *modelA = [array cl_objectAtIndex:1];
    WPGGamePageRanking *modelB = [array cl_objectAtIndex:0];
    WPGGamePageRanking *modelC = [array cl_objectAtIndex:2];
    
    UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *urlB = [NSURL URLWithString:modelB.avatar];
    [self.midAvatarImageView sd_setImageWithURL:urlB placeholderImage:defImg];
    self.midAvatarScoreLabel.text = [NSString stringWithFormat:@"%@", modelB.winsPoint];
    self.midAvatarNameLabel.text = modelB.nickname;
    NSURL *urlB_level = [NSURL URLWithString:modelB.winsLevel.icon];
    [self.midBadgesImage sd_setImageWithURL:urlB_level placeholderImage:defImg];
    _uidA2 = [NSString stringWithFormat:@"%@", @(modelB.uid)];
    
    
    NSURL *urlA = [NSURL URLWithString:modelA.avatar];
    [self.leftAvatarImageView sd_setImageWithURL:urlA placeholderImage:defImg];
    self.leftAvatarScoreLabel.text = [NSString stringWithFormat:@"%@", modelA.winsPoint];
    self.leftAvatarNameLabel.text = modelA.nickname;
    NSURL *urlA_level = [NSURL URLWithString:modelA.winsLevel.icon];
    [self.leftBadgesImage sd_setImageWithURL:urlA_level placeholderImage:defImg];
    _uidA1 = [NSString stringWithFormat:@"%@", @(modelA.uid)];
    
    NSURL *urlC = [NSURL URLWithString:modelC.avatar];
    [self.rightAvatarImageView sd_setImageWithURL:urlC placeholderImage:defImg];
    self.rightAvatarScoreLabel.text = [NSString stringWithFormat:@"%@", modelC.winsPoint];
    self.rightAvatarNameLabel.text = modelC.nickname;
    NSURL *urlC_level = [NSURL URLWithString:modelC.winsLevel.icon];
    [self.rightBadgesImage sd_setImageWithURL:urlC_level placeholderImage:defImg];
    _uidA3 = [NSString stringWithFormat:@"%@", @(modelC.uid)];
    [self justFrame];
}

- (NSMutableAttributedString *)adjustScoreLabelFontForm:(UILabel *)label
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:NF_Color_C1,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:13]} range:NSMakeRange(0, [label.text length])];
    NSRange tmpRange = [[[attributedString string] lowercaseString] rangeOfString:@"分"];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:NF_Color_C1,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:9]} range:tmpRange];
    return attributedString;
}

- (UIImageView *)floorLayerImageView
{
    if (!_floorLayerImageView) {
        _floorLayerImageView = [[UIImageView alloc] init];
        // 670 *195
        _floorLayerImageView.frame = CGRectMake(20, 178, 0, 0);
        _floorLayerImageView.image = [UIImage imageNamed:@"img_game_platform"];
        _floorLayerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _floorLayerImageView;
}

- (UIImageView *)leftPictureFrame
{
    if (!_leftPictureFrame) {
        _leftPictureFrame = [[UIImageView alloc] init];
        _leftPictureFrame.frame = CGRectMake(0, 0, 132, 123);
        _leftPictureFrame.image = [UIImage imageNamed:@"img_game_ranking2"];
        _leftPictureFrame.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftPictureFrame;
}

- (UIImageView *)midPictureFrame
{
    if (!_midPictureFrame) {
        _midPictureFrame = [[UIImageView alloc] init];
        _midPictureFrame.frame = CGRectMake(0, 0, 132, 123);
        _midPictureFrame.image = [UIImage imageNamed:@"img_game_ranking1"];
        _midPictureFrame.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _midPictureFrame;
}

- (UIImageView *)rightPictureFrame
{
    if (!_rightPictureFrame) {
        _rightPictureFrame = [[UIImageView alloc] init];
        _rightPictureFrame.frame = CGRectMake(0, 0, 132, 123);
        _rightPictureFrame.image = [UIImage imageNamed:@"img_game_ranking3"];
        _rightPictureFrame.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightPictureFrame;
}

- (UIImageView *)leftAvatarImageView
{
    if (!_leftAvatarImageView) {
        _leftAvatarImageView = [[UIImageView alloc] init];
        _leftAvatarImageView.frame = CGRectMake(0, 0, 66, 66);
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        _leftAvatarImageView.image = defImg;
        _leftAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftAvatarImageView.layer.cornerRadius = 27;
        _leftAvatarImageView.layer.masksToBounds = YES;
    }
    return _leftAvatarImageView;
}

- (UIImageView *)midAvatarImageView
{
    if (!_midAvatarImageView) {
        _midAvatarImageView = [[UIImageView alloc] init];
        _midAvatarImageView.frame = CGRectMake(0, 0, 66, 66);
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        _midAvatarImageView.image = defImg;
        _midAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _midAvatarImageView.layer.cornerRadius = 34.5;
        _midAvatarImageView.layer.masksToBounds = YES;
    }
    return _midAvatarImageView;
}

- (UIImageView *)rightAvatarImageView
{
    if (!_rightAvatarImageView) {
        _rightAvatarImageView = [[UIImageView alloc] init];
        _rightAvatarImageView.frame = CGRectMake(0, 0, 66, 66);
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        _rightAvatarImageView.image = defImg;
        _rightAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightAvatarImageView.layer.cornerRadius = 27;
        _rightAvatarImageView.layer.masksToBounds = YES;
    }
    return _rightAvatarImageView;
}

- (UILabel *)leftAvatarNameLabel
{
    if (!_leftAvatarNameLabel) {
        _leftAvatarNameLabel = [[UILabel alloc] init];
        _leftAvatarNameLabel.text = @"暂无人上榜";
        _leftAvatarNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _leftAvatarNameLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _leftAvatarNameLabel;
}

- (UILabel *)midAvatarNameLabel
{
    if (!_midAvatarNameLabel) {
        _midAvatarNameLabel = [[UILabel alloc] init];
        _midAvatarNameLabel.text = @"暂无人上榜";
        _midAvatarNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _midAvatarNameLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _midAvatarNameLabel;
}

- (UILabel *)rightAvatarNameLabel
{
    if (!_rightAvatarNameLabel) {
        _rightAvatarNameLabel = [[UILabel alloc] init];
        _rightAvatarNameLabel.text = @"暂无人上榜";
        _rightAvatarNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _rightAvatarNameLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _rightAvatarNameLabel;
}

- (UILabel *)leftAvatarScoreLabel
{
    if (!_leftAvatarScoreLabel) {
        _leftAvatarScoreLabel = [[UILabel alloc] init];
        _leftAvatarScoreLabel.text = @"0";
        _leftAvatarScoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _leftAvatarScoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
        _leftAvatarScoreLabel.alpha = 0.6f;
    }
    return _leftAvatarScoreLabel;
}

- (UILabel *)midAvatarScoreLabel
{
    if (!_midAvatarScoreLabel) {
        _midAvatarScoreLabel = [[UILabel alloc] init];
        _midAvatarScoreLabel.text = @"0";
        _midAvatarScoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _midAvatarScoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
        _midAvatarScoreLabel.alpha = 0.6f;
    }
    return _midAvatarScoreLabel;
}

- (UILabel *)rightAvatarScoreLabel
{
    if (!_rightAvatarScoreLabel) {
        _rightAvatarScoreLabel = [[UILabel alloc] init];
        _rightAvatarScoreLabel.text = @"0";
        _rightAvatarScoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _rightAvatarScoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
        _rightAvatarScoreLabel.alpha = 0.6f;
    }
    return _rightAvatarScoreLabel;
}

- (UIImageView *)leftBadgesImage
{
    if (!_leftBadgesImage) {
        _leftBadgesImage = [[UIImageView alloc] init];
        _leftBadgesImage.contentMode = UIViewContentModeScaleAspectFill;
        _leftBadgesImage.image = IDSImageNamed(@"ic_chart_badge1");
        _leftBadgesImage.layer.masksToBounds = YES;
    }
    return _leftBadgesImage;
}

- (UIImageView *)midBadgesImage
{
    if (!_midBadgesImage) {
        _midBadgesImage = [[UIImageView alloc] init];
        _midBadgesImage.contentMode = UIViewContentModeScaleAspectFill;
        _midBadgesImage.image = IDSImageNamed(@"ic_chart_badge1");
        _midBadgesImage.layer.masksToBounds = YES;
    }
    return _midBadgesImage;
}

- (UIImageView *)rightBadgesImage
{
    if (!_rightBadgesImage) {
        _rightBadgesImage = [[UIImageView alloc] init];
        _rightBadgesImage.contentMode = UIViewContentModeScaleAspectFill;
        _rightBadgesImage.image = IDSImageNamed(@"ic_chart_badge1");
        _rightBadgesImage.layer.masksToBounds = YES;
    }
    return _rightBadgesImage;
}

@end
