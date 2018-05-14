//
//  WPGamePersonCenterBottomView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGamePersonCenterBottomView.h"

@implementation WPGamePersonCenterBottomView

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
    self.backgroundColor = NF_Color_C1;
    [self addSubview:self.chatImageView];
    [self addSubview:self.chatLabel];
    [self addSubview:self.friendImageView];
    [self addSubview:self.friendLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
    self.lineView.frame = CGRectMake(0, 0, 1, 30);
    self.lineView.centerX = self.bounds.size.width / 2.0;
    self.lineView.centerY = self.bounds.size.height / 2.0;
    
    CGFloat centerY = 55/2.0;
    CGFloat startX = SCREEN_WIDTH/4.0 - (14+self.friendLabel.contentSize.width+24)/2.0;
    self.friendImageView.frame = CGRectMake(startX, 0, 24, 24);
    self.friendImageView.centerY = centerY;
    
    self.friendLabel.frame = CGRectMake(CGRectGetMaxX(self.friendImageView.frame)+14, 0, 0, 0);
    [self.friendLabel sizeToFit];
    self.friendLabel.centerY = centerY;
    
    self.chatImageView.frame = CGRectMake(startX+SCREEN_WIDTH/2.0, 0, 24, 24);
    self.chatImageView.centerY = centerY;
    
    self.chatLabel.frame = CGRectMake(CGRectGetMaxX(self.chatImageView.frame)+14, 0, 0, 0);
    [self.chatLabel sizeToFit];
    self.chatLabel.centerY = centerY;
    
    self.leftView.userInteractionEnabled = YES;
    self.rightView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    
    self.leftView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0, 55);
    self.rightView.frame = CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 55);
    
    UITapGestureRecognizer *lefttapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriendVoid)];
    [self.leftView addGestureRecognizer:lefttapgesture];
    
    UITapGestureRecognizer *righttapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatVoid)];
    [self.rightView addGestureRecognizer:righttapgesture];
}

- (void)isNotMyFriend
{
    self.friendLabel.hidden = NO;
    self.friendImageView.hidden = NO;
    self.lineView.hidden = NO;
    
    self.friendLabel.text = @"加好友";
    self.friendLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
    [self.friendLabel sizeToFit];
    self.leftView.userInteractionEnabled = YES;
    self.chatLabel.text = @"打招呼";
    [self.chatLabel sizeToFit];
    
    self.lineView.frame = CGRectMake(0, 0, 1, 30);
    self.lineView.centerX = self.bounds.size.width / 2.0;
    self.lineView.centerY = self.bounds.size.height / 2.0;
    
    CGFloat centerY = 55/2.0;
    CGFloat startX = SCREEN_WIDTH/4.0 - (14+self.friendLabel.contentSize.width+24)/2.0;
    self.friendImageView.frame = CGRectMake(startX, 0, 24, 24);
    self.friendImageView.centerY = centerY;
    
    self.friendLabel.frame = CGRectMake(CGRectGetMaxX(self.friendImageView.frame)+14, 0, 0, 0);
    [self.friendLabel sizeToFit];
    self.friendLabel.centerY = centerY;
    
    self.chatImageView.frame = CGRectMake(startX+SCREEN_WIDTH/2.0, 0, 24, 24);
    self.chatImageView.centerY = centerY;
    
    self.chatLabel.frame = CGRectMake(CGRectGetMaxX(self.chatImageView.frame)+14, 0, 0, 0);
    [self.chatLabel sizeToFit];
    self.chatLabel.centerY = centerY;
    
    self.chatImageView.image = [UIImage imageNamed:@"ic_personal_hi"];
    self.friendImageView.image = [UIImage imageNamed:@"ic_personal_friend_normal"];
    
    self.leftView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0, 55);
    self.rightView.frame = CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 55);
}

- (void)waitToVerify
{
    self.friendLabel.hidden = NO;
    self.friendImageView.hidden = NO;
    self.lineView.hidden = NO;
    
    self.friendLabel.text = @"等待通过";
    self.friendLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
    [self.friendLabel sizeToFit];
    self.leftView.userInteractionEnabled = NO;
    self.chatLabel.text = @"打招呼";
    [self.chatLabel sizeToFit];
    
    self.lineView.frame = CGRectMake(0, 0, 1, 30);
    self.lineView.centerX = self.bounds.size.width / 2.0;
    self.lineView.centerY = self.bounds.size.height / 2.0;
    
    CGFloat centerY = 55/2.0;
    CGFloat startX = SCREEN_WIDTH/4.0 - (14+self.friendLabel.contentSize.width+24)/2.0;
    self.friendImageView.frame = CGRectMake(startX, 0, 24, 24);
    self.friendImageView.centerY = centerY;
    
    self.friendLabel.frame = CGRectMake(CGRectGetMaxX(self.friendImageView.frame)+14, 0, 0, 0);
    [self.friendLabel sizeToFit];
    self.friendLabel.centerY = centerY;
    
    self.chatImageView.frame = CGRectMake(startX+SCREEN_WIDTH/2.0, 0, 24, 24);
    self.chatImageView.centerY = centerY;
    
    self.chatLabel.frame = CGRectMake(CGRectGetMaxX(self.chatImageView.frame)+14, 0, 0, 0);
    [self.chatLabel sizeToFit];
    self.chatLabel.centerY = centerY;
    
    self.chatImageView.image = [UIImage imageNamed:@"ic_personal_hi"];
    self.friendImageView.image = [UIImage imageNamed:@"ic_personal_friend_invalid"];
    
    self.leftView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0, 55);
    self.rightView.frame = CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 55);
}

- (void)isMyFriend
{
    self.friendLabel.hidden = YES;
    self.friendImageView.hidden = YES;
    self.lineView.hidden = YES;
    
    self.chatLabel.text = @"聊天";
    [self.chatLabel sizeToFit];
    
    CGFloat centerY = 55/2.0;
    CGFloat startX = SCREEN_WIDTH/2.0 - (16+self.friendLabel.contentSize.width+24)/2.0;
   
    self.chatImageView.frame = CGRectMake(startX, 0, 24, 24);
    self.chatImageView.centerY = centerY;
    
    self.chatLabel.frame = CGRectMake(CGRectGetMaxX(self.chatImageView.frame)+16, 0, 0, 0);
    [self.chatLabel sizeToFit];
    self.chatLabel.centerY = centerY;
    
    self.chatImageView.image = [UIImage imageNamed:@"ic_personal_chat"];
    
    self.rightView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
}

- (void)iHateHim
{
    self.friendLabel.hidden = NO;
    self.friendImageView.hidden = NO;
    self.lineView.hidden = NO;
    self.leftView.userInteractionEnabled = NO;
    self.friendLabel.text = @"禁止加好友";
    self.friendLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
    [self.friendLabel sizeToFit];
    self.chatLabel.text = @"打招呼";
    [self.chatLabel sizeToFit];
    
    self.lineView.frame = CGRectMake(0, 0, 1, 30);
    self.lineView.centerX = self.bounds.size.width / 2.0;
    self.lineView.centerY = self.bounds.size.height / 2.0;
    
    CGFloat centerY = 55/2.0;
    CGFloat startX = SCREEN_WIDTH/4.0 - (14+self.friendLabel.contentSize.width+24)/2.0;
    self.friendImageView.frame = CGRectMake(startX, 0, 24, 24);
    self.friendImageView.centerY = centerY;
    
    self.friendLabel.frame = CGRectMake(CGRectGetMaxX(self.friendImageView.frame)+14, 0, 0, 0);
    [self.friendLabel sizeToFit];
    self.friendLabel.centerY = centerY;
    
    self.chatImageView.frame = CGRectMake(startX+SCREEN_WIDTH/2.0, 0, 24, 24);
    self.chatImageView.centerY = centerY;
    
    self.chatLabel.frame = CGRectMake(CGRectGetMaxX(self.chatImageView.frame)+14, 0, 0, 0);
    [self.chatLabel sizeToFit];
    self.chatLabel.centerY = centerY;
    
    self.chatImageView.image = [UIImage imageNamed:@"ic_personal_hi"];
    self.friendImageView.image = [UIImage imageNamed:@"ic_personal_friend_normal"];
    
    self.leftView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0, 55);
    self.rightView.frame = CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 55);
}

- (void)dataWithFriendStatus:(NSInteger)friendStatus
{
    if (friendStatus == 0) {
        [self isNotMyFriend];
    }
    else if (friendStatus == 1) {
        [self isMyFriend];
    }
    else if (friendStatus == 2){
        [self waitToVerify];
    }
    else {
        [self iHateHim];
    }
}

- (void)addFriendVoid
{
    [self waitToVerify];
    if (self.delegate && [self.delegate respondsToSelector:@selector(addFriendAction:)]) {
        [self.delegate addFriendAction:self];
    }
    TRACK_SECOND_LEVEL_CLICK(@"profile", @"add_friend", nil);
}

- (void)chatVoid
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatAction:)]) {
        [self.delegate chatAction:self];
    }
    TRACK_SECOND_LEVEL_CLICK(@"profile", @"say_hi", nil);
}

- (UIImageView *)friendImageView
{
    if (!_friendImageView) {
        _friendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _friendImageView.image = [UIImage imageNamed:@"ic_personal_friend_normal"];
        _friendImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _friendImageView;
}

- (UIImageView *)chatImageView
{
    if (!_chatImageView) {
        _chatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _chatImageView.image = [UIImage imageNamed:@"ic_personal_hi"];
        _chatImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _chatImageView;
}

- (UILabel *)friendLabel
{
    if (!_friendLabel) {
        _friendLabel = [[UILabel alloc] init];
        _friendLabel.text = @"加好友";
        _friendLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _friendLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
        [_friendLabel sizeToFit];
    }
    return _friendLabel;
}

- (UILabel *)chatLabel
{
    if (!_chatLabel) {
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.text = @"打招呼";
        _chatLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _chatLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
        [_chatLabel sizeToFit];
    }
    return _chatLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
        _lineView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
    }
    return _lineView;
}

- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

@end
