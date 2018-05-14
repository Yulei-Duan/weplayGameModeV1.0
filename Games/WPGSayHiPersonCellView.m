//
//  WPGSayHiPersonCellView.m
//  WePlayGame
//
//  Created by leviduan on 2018/5/3.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGSayHiPersonCellView.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>
#import "WPGChatRecommendModel.h"

@interface WPGSayHiPersonCellView()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *genderImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *chatLabel;
@property (nonatomic, strong) UIImageView *chatBackgroundView;

@end

@implementation WPGSayHiPersonCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView
{
    [self addSubview:self.avatarImageView];
    [self addSubview:self.genderImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.chatBackgroundView];
    [self addSubview:self.chatLabel];
    [self viewAdjustFrame];
}

- (void)viewLoadDataWithModel:(WPGChatRecommendModel *)chatmodel
{
    if (!chatmodel) return;
    
    if (IS_NS_STRING_EMPTY(chatmodel.userInfo.nickname)) {
        chatmodel.userInfo.nickname = @"未命名";
    }
    
    if (IS_NS_STRING_EMPTY(chatmodel.text)) {
        chatmodel.text = @"处CP么";
    }
    
    UIImage *defImg = [IDSImageManager defaultAvatar:SquareStyle];
    NSURL *avatar_url = [NSURL URLWithString:chatmodel.userInfo.avatar];
    [self.avatarImageView sd_setImageWithURL:avatar_url placeholderImage:defImg];
    self.nameLabel.text = chatmodel.userInfo.nickname;
    self.chatLabel.text = chatmodel.text;
    // @gender:0-男人 1-女人
    if (chatmodel.userInfo.gender) {
        self.genderImageView.image = IDSImageNamed(@"img_female_chat");
    }
    else {
        self.genderImageView.image = IDSImageNamed(@"img_male_chat");
    }
    [self viewAdjustFrame];
}

- (void)viewAdjustFrame
{
    // 布局按照蓝湖标注进行基础Frame布局
    self.avatarImageView.frame = CGRectMake(26, 4, 50, 50);
    self.genderImageView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)-13, CGRectGetMaxY(self.avatarImageView.frame)-13, 13, 13);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, 0, 0, 0);
    [self.nameLabel sizeToFit];
    
    [self.chatLabel sizeToFit];
    self.chatBackgroundView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, CGRectGetMaxY(self.nameLabel.frame)+5, self.chatLabel.contentSize.width+26, 40);
    self.chatLabel.centerX = self.chatBackgroundView.centerX;
    self.chatLabel.centerY = self.chatBackgroundView.centerY;
}

#pragma mark - lazy initialization

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleToFill;
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        _avatarImageView.image = defImg;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.layer.cornerRadius = 25.f;
    }
    return _avatarImageView;
}

- (UIImageView *)genderImageView
{
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
        _genderImageView.image = IDSImageNamed(@"img_male_chat");
        _genderImageView.contentMode = UIViewContentModeScaleAspectFill;
        _genderImageView.layer.masksToBounds = YES;
    }
    return _genderImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"未命名";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)chatLabel
{
    if (!_chatLabel) {
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.text = @"处CP么";
        _chatLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _chatLabel.textColor = [UIColor whiteColor];
    }
    return _chatLabel;
}

- (UIImageView *)chatBackgroundView
{
    if (!_chatBackgroundView) {
        _chatBackgroundView = [[UIImageView alloc] init];
        //_chatBackgroundView.image = [UIImage imageNamed:@"img_signin_chat"];
        _chatBackgroundView.layer.masksToBounds = YES;
    }
    UIImage *image = [UIImage imageNamed:@"img_signin_chat"];
    _chatBackgroundView.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.width*1.0];
    return _chatBackgroundView;
}

@end
