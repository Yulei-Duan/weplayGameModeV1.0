//
//  WPGSayHiView.m
//  WePlayGame
//
//  Created by leviduan on 2018/5/3.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGSayHiView.h"
#import "WPGSayHiPersonCellView.h"
#import "WPGChatRecommendModel.h"

@interface WPGSayHiView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *sayHiImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *sayHiBtnLabel;

@end

@implementation WPGSayHiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithModel:(NSArray<WPGChatRecommendModel *> *)modelArray
{
    self = [self initWithFrame:frame];
    if (self) {
        [self dataWithModelArray:modelArray];
    }
    return self;
}

- (void)initWithView
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.sayHiImageView];
    [self addSubview:self.sayHiBtnLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openButtonVoid)];
    self.sayHiImageView.userInteractionEnabled = YES;
    [self.sayHiImageView addGestureRecognizer:tapGesture];
    
    CGFloat startY = 140.f;
    if (IS_IPHONE_5) {
        startY = 90.f;
    }
    for (int i=1000;i<1005;++i) {
        WPGSayHiPersonCellView *chatView = [[WPGSayHiPersonCellView alloc] init];
        chatView.frame = CGRectMake(0, startY, SCREEN_WIDTH, 65);
        chatView.tag = i;
        if (IS_IPHONE_5) {
            startY+=(10+65);
        }
        else {
            startY+=(16+65);
        }
        [self addSubview:chatView];
    }
    
    [self viewAdjustFrame];
}

- (void)dataWithModelArray:(NSArray<WPGChatRecommendModel *> *)modelArray
{
    if (modelArray.count < 5) {
        return;
    }
    for (int i=1000;i<1005;++i) {
        WPGSayHiPersonCellView *chatView = (WPGSayHiPersonCellView *)[self viewWithTag:i];
        WPGChatRecommendModel *model = modelArray[i-1000];
        [chatView viewLoadDataWithModel:model];
    }
    [self viewAdjustFrame];
}

- (void)viewAdjustFrame
{
    self.backgroundImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat centerX = SCREEN_WIDTH / 2.0;
    self.titleLabel.frame = CGRectMake(0, 45, 0, 0);
    if (IS_IPHONE_5) {
        self.titleLabel.frame = CGRectMake(0, 25, 0, 0);
    }
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = centerX;
    
    self.sayHiImageView.frame = CGRectMake(0, SCREEN_HEIGHT-36-49, 150, 49);
    if (IS_IPHONE_X) {
        self.sayHiImageView.frame = CGRectMake(0, SCREEN_HEIGHT-36-49-34, 150, 49);
    }
    self.sayHiImageView.centerX = centerX;
    [self.sayHiBtnLabel sizeToFit];
    self.sayHiBtnLabel.centerX = self.sayHiImageView.centerX;
    self.sayHiBtnLabel.centerY = self.sayHiImageView.centerY-2;
}

- (void)openButtonVoid
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPlayButton:)]) {
        [self.delegate clickPlayButton:self];
    }
}

#pragma mark - lazy initialization.

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"兴趣相同的TA";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
        _titleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
    }
    return _titleLabel;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"bg_signin_background"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (UIImageView *)sayHiImageView
{
    if (!_sayHiImageView) {
        _sayHiImageView = [[UIImageView alloc] init];
        _sayHiImageView.image = [UIImage imageNamed:@"btn_signin_start"];
    }
    return _sayHiImageView;
}

- (UILabel *)sayHiBtnLabel
{
    if (!_sayHiBtnLabel) {
        _sayHiBtnLabel = [[UILabel alloc] init];
        _sayHiBtnLabel.text = @"开玩";
        _sayHiBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _sayHiBtnLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
    }
    return _sayHiBtnLabel;
}

@end
