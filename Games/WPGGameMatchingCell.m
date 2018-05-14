//
//  WPGGameMatchingCell.m
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGGameMatchingCell.h"
#import "IDSImageManager.h"
#import "UIImageView+WebCache.h"

//如果是ipad则用768宽度为比例，否则用375作为比例
#define IS_PADWidth (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad ? 512 : 375)

#define ProportionWidth [UIScreen mainScreen].bounds.size.width/IS_PADWidth
/**字体比例*/
#define CZH_ScaleFont(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/IS_PADWidth)*(__VA_ARGS__)
/**全局字体*/
#define CZHGlobelNormalFont(__VA_ARGS__) ([UIFont systemFontOfSize:CZH_ScaleFont(__VA_ARGS__)])

@implementation WPGGameMatchingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.font = CZHGlobelNormalFont(15);
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    _leftLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    [self.contentView addSubview:_leftLabel];
    
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.clipsToBounds = YES;
    _iconImage.layer.cornerRadius = (36*ProportionWidth)/2;
    [self.contentView addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
    _nameLabel.font = CZHGlobelNormalFont(14);;
    [self.contentView addSubview:_nameLabel];
    
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
    _scoreLabel.font = CZHGlobelNormalFont(15);
    [self.contentView addSubview:_scoreLabel];

    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(-3*ProportionWidth);
        make.right.mas_equalTo(_iconImage.mas_left);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(41*ProportionWidth);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(-3*ProportionWidth);
        make.width.height.mas_equalTo(36*ProportionWidth);
    }];
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-(8*ProportionWidth));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImage.mas_right).with.offset(10*ProportionWidth);
        make.right.mas_lessThanOrEqualTo(_scoreLabel.mas_left).with.offset(-(5*ProportionWidth));
        make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(-3*ProportionWidth);
    }];
    

}


-(void)setModel:(MatchList *)model{
        
    _nameLabel.text = model.nickname ? model.nickname : @"";
    UIImage *defImage = [IDSImageManager defaultAvatar:CircleStyle];
    [_iconImage  sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:defImage];//顶部自己头像
    _scoreLabel.text = model.winsPoint ? model.winsPoint : @"";
//    if (model.winsPoint && ![model.winsPoint isEqualToString:@""]) {
//        [self mutableAttributeSting:model.winsPoint];
//    }else{
//        [self mutableAttributeSting:@"0"];
//    }
    
}

- (void)mutableAttributeSting:(NSString *)str{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    NSDictionary *dictAttr1 = @{NSFontAttributeName:CZHGlobelNormalFont(13),
                                NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#333333"]};
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str attributes:dictAttr1];
    [attrString appendAttributedString:attr1];
    
    NSDictionary *dictAttr2 = @{NSFontAttributeName:CZHGlobelNormalFont(9),
                                NSForegroundColorAttributeName:[ColorUtil cl_colorWithHexString:@"#999999"]};
    NSAttributedString *attr2 = [[NSAttributedString alloc]initWithString:@" 分" attributes:dictAttr2];
    [attrString appendAttributedString:attr2];
    _scoreLabel.attributedText = attrString;
}


@end
