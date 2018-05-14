//
//  WPGamePageEveryTaskCollectionViewCell.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/16.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGamePageEveryTaskCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "IDSImageManager.h"
#import <UIImageView+WebCache.h>
#import "WPGGamePageRequest.h"

@implementation WPGamePageEveryTaskCollectionViewCell

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
    self.userInteractionEnabled = YES;
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.avatarImageview];
    [self addSubview:self.nameLabel];
    [self addSubview:self.moneyIconImageView];
    [self addSubview:self.expIconImageView];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.expLabel];
    [self addSubview:self.receiveBtn];
    [self addSubview:self.progressLabel];
    [self addSubview:self.horizontalLine];
    [self addSubview:self.verticalLine];
    [self addSubview:self.unitLabel];
    [self addSubview:self.progressbar_bottomView];
    [self addSubview:self.progressbar_topView];
    [self addSubview:self.maskLayerView];
    [self.progressbar_topView addSubview:self.progressbar_midView];
    [self adjustFrame];
    self.maskLayerView.hidden = YES;
}

- (void)cellWithData:(WPGameTaskModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
    NSURL *avatar_url = [NSURL URLWithString:model.icon];
    
    // 判断字段是否存在，以防复用
    if (IS_NS_STRING_EMPTY(model.title)) model.title = @"无任务";
    [self.avatarImageview sd_setImageWithURL:avatar_url placeholderImage:defImg];
    self.nameLabel.text = model.title;
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@", @(model.money)];
    self.expLabel.text = [NSString stringWithFormat:@"+%@", @(model.exp)];
    self.progressLabel.text = [NSString stringWithFormat:@"%@/%@", model.task_completed, model.number];
    self.maskLayerView.hidden = YES;
    // 领取状态 0=前往, 1=可领取, 2=已领取
    if (model.taskStatus == 0) {
        self.maskLayerView.hidden = YES;
        self.receiveBtn.selected = YES;
        [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"btn_task_receive_selected"] forState:UIControlStateNormal];
        [self.receiveBtn setTitle:@"未完成" forState:UIControlStateSelected];
        [self.receiveBtn setTitleColor:[ColorUtil cl_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    }
    else if (model.taskStatus == 1) {
        self.maskLayerView.hidden = YES;
        self.receiveBtn.selected = NO;
        [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"btn_task_receive_normal"] forState:UIControlStateNormal];
        [self.receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:[ColorUtil cl_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }
    else {
        self.maskLayerView.hidden = NO;
        self.receiveBtn.selected = YES;
        [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"btn_task_receive_selected"] forState:UIControlStateNormal];
        [self.receiveBtn setTitle:@"已领取" forState:UIControlStateSelected];
        [self.receiveBtn setTitleColor:[ColorUtil cl_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    }
    [self adjustFrame];
    
    CGFloat expRate;
    if (model.number) {
        expRate = model.task_completed.integerValue*1.0/model.number.integerValue*1.0;
    }
    else {
        expRate = 0;
    }
    [self getExp:expRate];
}

- (void)getExp:(CGFloat)expRate
{
    CGFloat progressStart = CGRectGetMinX(self.unitLabel.frame);
    CGFloat progressEnd = self.bounds.size.width-88;
    CGFloat progressbarLength = progressEnd - progressStart;
    self.progressbar_topView.frame = CGRectMake(progressStart, CGRectGetMaxY(self.unitLabel.frame)+2, progressbarLength*expRate, 8);
    self.progressbar_topView.clipsToBounds = YES;
    self.progressbar_topView.layer.masksToBounds = YES;
}

- (void)adjustFrame
{
    CGFloat centerY = 88/2.0;
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH-20, 88);
    self.userInteractionEnabled = YES;
    self.backgroundImageView.frame = self.bounds;
    self.avatarImageview.frame = CGRectMake(17, 0, 50, 50);
    self.avatarImageview.centerY = centerY;
    
    self.verticalLine.frame = CGRectMake(CGRectGetMaxX(self.avatarImageview.frame)+11, 0, 1, 85);
    self.verticalLine.centerY = centerY;
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.verticalLine.frame)+9, 9, 0, 0);
    [self.nameLabel sizeToFit];
    
    self.horizontalLine.frame = CGRectMake(CGRectGetMaxX(self.verticalLine.frame), 37, self.bounds.size.width-CGRectGetMaxX(self.verticalLine.frame)-3, 1);
    
    self.unitLabel.frame = CGRectMake(CGRectGetMaxX(self.verticalLine.frame)+9, CGRectGetMaxY(self.horizontalLine.frame)+5, 0, 0);
    [self.unitLabel sizeToFit];
    
    CGFloat progressStart = CGRectGetMinX(self.unitLabel.frame);
    CGFloat progressEnd = self.bounds.size.width-88;
    [self.progressLabel sizeToFit];
    self.progressLabel.frame = CGRectMake(progressEnd-self.progressLabel.width, 0, 0, 0);
    [self.progressLabel sizeToFit];
    self.progressLabel.centerY = self.unitLabel.centerY;
    
    [self.expLabel sizeToFit];
    [self.moneyLabel sizeToFit];
    self.expLabel.frame = CGRectMake(self.bounds.size.width-12-self.expLabel.contentSize.width, 12, 0, 0);
    [self.expLabel sizeToFit];
    self.expIconImageView.frame = CGRectMake(CGRectGetMinX(self.expLabel.frame)-2-14, 0, 14, 15);
    self.expIconImageView.centerY = self.expLabel.centerY;

    self.moneyLabel.frame = CGRectMake(CGRectGetMinX(self.expIconImageView.frame)-10-self.moneyLabel.contentSize.width, 0, 0, 0);
    [self.moneyLabel sizeToFit];
    self.moneyLabel.centerY = self.expLabel.centerY;
    
    self.moneyIconImageView.frame = CGRectMake(CGRectGetMinX(self.moneyLabel.frame)-2-16, 0, 16, 16);
    self.moneyIconImageView.centerY = self.expLabel.centerY;
    
    self.receiveBtn.frame = CGRectMake(self.bounds.size.width-12-67, 44, 67, 34);
    [self.receiveBtn addTarget:self action:@selector(clickBtnVoid:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat progressbarLength = progressEnd - progressStart;
    
    self.progressbar_bottomView.frame = CGRectMake(progressStart, CGRectGetMaxY(self.unitLabel.frame)+2, progressbarLength, 8);
    self.progressbar_midView.frame = CGRectMake(0, 0, progressbarLength, 8);
    self.progressbar_topView.frame = CGRectMake(progressStart, CGRectGetMaxY(self.unitLabel.frame)+2, progressbarLength/2.0, 8);
    self.progressbar_topView.layer.masksToBounds = YES;
    
    self.maskLayerView.frame = CGRectMake(0, 0, self.bounds.size.width-8, self.bounds.size.height-2);
    self.maskLayerView.centerX = self.bounds.size.width/2.0;
    self.maskLayerView.centerY = self.bounds.size.height/2.0;
}

- (void)clickBtnVoid:(UIButton *)btn
{
    if (btn.selected == YES) {
        return;
    }
    self.maskLayerView.hidden = NO;
    self.receiveBtn.selected = 1;
    [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"btn_task_receive_selected"] forState:UIControlStateNormal];
    [self.receiveBtn setTitle:@"已领取" forState:UIControlStateSelected];
    [self.receiveBtn setTitleColor:[ColorUtil cl_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _model.taskStatus = 2;
    if (self.delegate && [self.delegate respondsToSelector:@selector(receiveTheTask:andTaskModel:)]) {
        [self.delegate receiveTheTask:self andTaskModel:_model];
    }
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = IDSImageNamed(@"bg_task_ranks");
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.layer.masksToBounds = YES;
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}

- (UIImageView *)avatarImageview
{
    if (!_avatarImageview) {
        _avatarImageview = [[UIImageView alloc] init];
        _avatarImageview.contentMode = UIViewContentModeScaleToFill;
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        _avatarImageview.image = defImg;
        _avatarImageview.layer.masksToBounds = YES;
        _avatarImageview.userInteractionEnabled = YES;
        _avatarImageview.layer.cornerRadius = 25.f;
    }
    return _avatarImageview;
}

- (UIImageView *)moneyIconImageView
{
    if (!_moneyIconImageView) {
        _moneyIconImageView = [[UIImageView alloc] init];
        _moneyIconImageView.image = IDSImageNamed(@"ic_task_gold");
        _moneyIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _moneyIconImageView.layer.masksToBounds = YES;
        _moneyIconImageView.userInteractionEnabled = YES;
    }
    return _moneyIconImageView;
}

- (UIImageView *)expIconImageView
{
    if (!_expIconImageView) {
        _expIconImageView = [[UIImageView alloc] init];
        _expIconImageView.image = IDSImageNamed(@"ic_task_exp");
        _expIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _expIconImageView.layer.masksToBounds = YES;
        _expIconImageView.userInteractionEnabled = YES;
    }
    return _expIconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _nameLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
        _nameLabel.text = @" ";
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _moneyLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
        _moneyLabel.text = @"+0";
    }
    return _moneyLabel;
}

- (UILabel *)expLabel
{
    if (!_expLabel) {
        _expLabel = [[UILabel alloc] init];
        _expLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _expLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
        _expLabel.text = @"+0";
    }
    return _expLabel;
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _progressLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
        _progressLabel.text = @"0/1";
    }
    return _progressLabel;
}

- (UILabel *)unitLabel
{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _unitLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
        _unitLabel.text = @"进度";
    }
    return _unitLabel;
}


- (UIButton *)receiveBtn
{
    if (!_receiveBtn) {
        _receiveBtn = [[UIButton alloc] init];
        [_receiveBtn setBackgroundImage:[UIImage imageNamed:@"btn_task_receive"] forState:UIControlStateNormal];
        [_receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
        [_receiveBtn setTitleColor:[ColorUtil cl_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_receiveBtn setTitle:@"已领取" forState:UIControlStateSelected];
        [_receiveBtn setTitleColor:[ColorUtil cl_colorWithHexString:@"#999999"] forState:UIControlStateSelected];
        _receiveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    }
    return _receiveBtn;
}

- (UIView *)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = [ColorUtil cl_colorWithHexString:@"#EFEFEF"];
    }
    return _horizontalLine;
}

- (UIView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = [ColorUtil cl_colorWithHexString:@"#EFEFEF"];
    }
    return _verticalLine;
}

- (UIView *)progressbar_topView
{
    if (!_progressbar_topView) {
        _progressbar_topView = [[UIView alloc] init];
        //_progressbar_topView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FFD86F"];
        _progressbar_topView.layer.cornerRadius = 4.0f;
    }
    return _progressbar_topView;
}

- (UIView *)progressbar_bottomView
{
    if (!_progressbar_bottomView) {
        _progressbar_bottomView = [[UIView alloc] init];
        _progressbar_bottomView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#F1F5F8"];
        _progressbar_bottomView.layer.cornerRadius = 4.0f;
    }
    return _progressbar_bottomView;
}

- (UIImageView *)progressbar_midView
{
    if (!_progressbar_midView) {
        _progressbar_midView = [[UIImageView alloc] init];
        _progressbar_midView.image = [UIImage imageNamed:@"img_task_rate"];
        _progressbar_midView.layer.cornerRadius = 4.0f;
    }
    return _progressbar_midView;
}

- (UIView *)maskLayerView
{
    if (!_maskLayerView) {
        _maskLayerView = [[UIView alloc] init];
        _maskLayerView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
        _maskLayerView.alpha = 0.6f;
    }
    return _maskLayerView;
}

@end
