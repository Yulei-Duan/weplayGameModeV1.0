//
//  WPGGameMatchingVC.m
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGGameMatchingVC.h"

#import "WPGGameMatchingCell.h"
#import "WPGGameMatchingModel.h"
#import "WPGH5GameController.h"
#import "WPGGamePageRequest.h"
#import "IDSSharedPopupWindow.h"
#import "WPGGameShareModel.h"
#import "WPGTaskGiftBagModel.h"
#import "WPGGiftBagWindowView.h"
#import "WPGSubGameRankPage.h"
#import "WPGTheRulesView.h"


#define scoreBtnCount 3

//如果是ipad则用768宽度为比例，否则用375作为比例
#define IS_PADWidth (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad ? 512 : 375)

#define ProportionWidth [UIScreen mainScreen].bounds.size.width/IS_PADWidth
/**字体比例*/
#define CZH_ScaleFont(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/IS_PADWidth)*(__VA_ARGS__)
/**全局字体*/
#define CZHGlobelNormalFont(__VA_ARGS__) ([UIFont systemFontOfSize:CZH_ScaleFont(__VA_ARGS__)])

#define isPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)

@interface WPGGameMatchingVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIImageView *backImage;//VC背景图

@property (nonatomic, strong) UIView *navView;//导航栏

@property (nonatomic, strong) UIButton *navRightBtn;//导航栏右边按钮

@property (nonatomic, strong) UIButton *navLeftBtn;//导航栏右边按钮

@property (nonatomic, strong) UILabel *navTitleLabel;//导航栏标题按钮

@property (nonatomic, assign) CGFloat navHeight;//导航栏高度

@property (nonatomic, strong) UIImageView *windowImage;//弹窗view

@property (nonatomic, strong) UIImageView *topMyIconImage;//弹窗顶部用户自己头像

@property (nonatomic, strong) UILabel *topNameLabel;//顶部用户你昵称

@property (nonatomic, strong) UIView *scoreBackview;//评分父view

@property (nonatomic, strong) UILabel *scoreBroughtOutLabel;//今日奖励已领完提示

@property (nonatomic, strong) UIButton *scoreBtn;//评分星星btn

@property (nonatomic, strong) UIButton *giftBtn;//星星右边礼物btn

@property (nonatomic, strong) UIImageView *giftTopImage;//抖动礼物

@property (nonatomic, strong) UIImageView *listTitleImage;//达人榜title

@property (nonatomic, strong) UITableView *tableView;//排行榜列表

@property (nonatomic, strong) UIView *bottomMyGiftView;//底部自己排名view

@property (nonatomic, strong) UILabel *myLeftLabel;//自己的排名

@property (nonatomic, strong) UIImageView *myIconImage;//我的头像

@property (nonatomic, strong) UILabel *myNameLabel;//我的名字

@property (nonatomic, strong) UILabel *myScoreLabel;//我的分数

@property (nonatomic, strong) UIImageView *myRightImage;//我的信息右边箭头

@property (nonatomic, strong) UIImageView *myTopView;//自己排名与他人排名分割线

@property (nonatomic, strong) NSMutableArray *listArray;//排行榜数组

@property (nonatomic, strong) NSArray *leftImageArray;

@property (nonatomic, strong) UIButton *friendBtn;//邀请好友

@property (nonatomic, strong) UIButton *starMatch;//开始匹配

@property (nonatomic, strong) WPGGameMatchingModel *model;

@property (nonatomic, strong) WPGGameShareModel *shareModel;


@end


@implementation WPGGameMatchingVC

- (instancetype)init
{
    return [self initWithGameId:@"" gameName:@""];
}

- (instancetype)initWithGameId:(NSString *)gameId gameName:(NSString *)aGameName{
    
    if (self = [super init]) {
        _ganmeId   = gameId;
        _gameName = aGameName;
        _listArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    _navHeight = isPhoneX ? 88 : 64;
    _leftImageArray = @[@"1",@"2",@"3"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess) name:kWXShareNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:kWPGGameFinishedBack object:nil];
    
    [self initBackView];//背景view
    
    [self initNavView];//导航栏
    
    _navTitleLabel.text = _gameName;
    
    [self initData];
    
}

- (BOOL)preferredNavigationBarHidden
{
    return YES;
}

- (void)initData{

    @weakify(self);
    [WPGGamePageRequest starGamesWithgGameId:self.ganmeId Success:^(id responseObj) {
        
        @strongify(self);
        if ([self isNotEmpty:responseObj[@"data"]]) {
            
            self.model = [WPGGameMatchingModel mj_objectWithKeyValues:responseObj[@"data"]];
            
            // 重新赋值, 防止传入参数为空, 显示出现问题
            self.ganmeId = self.model.gameInfo.gameId;
            self.gameName = self.model.gameInfo.name;
            _navTitleLabel.text = _gameName;
            
            [self.listArray removeAllObjects];
            
            [self.listArray addObjectsFromArray:self.model.list];
            [self initwindowView];//窗口view、邀请好友btn、开始匹配btn
            [self viewLoadingData];//显示数据
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

//获取分享信息
- (void) initShareData{
    
    [WPGGamePageRequest gameShareInfoWithGameId:self.ganmeId Success:^(id responseObj) {
        
        if ([self isNotEmpty:responseObj]) {
            
            _shareModel = [WPGGameShareModel mj_objectWithKeyValues:responseObj];
            [self shareIconView];//调起分享弹窗
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)viewLoadingData{
    
    UIImage *defImage = [IDSImageManager defaultAvatar:CircleStyle];
    [self.topMyIconImage  sd_setImageWithURL:[NSURL URLWithString:_model.user.avatar] placeholderImage:defImage];//顶部自己头像
    self.topNameLabel.text = _model.user.nickname ? _model.user.nickname : @"";//顶部用户昵称
    
    [self scoreViewLoadData];//星星评分数据
    
    if (!_model.user.ranking ||  _model.user.ranking == 0) {
        self.myLeftLabel.text = @"未上榜";
        self.myLeftLabel.font = CZHGlobelNormalFont(10);
    }else{
        self.myLeftLabel.text = [NSString stringWithFormat:@"%ld",_model.user.ranking];//底部用户自己排名
    }
    
    [self.myIconImage sd_setImageWithURL:[NSURL URLWithString:_model.user.avatar] placeholderImage:defImage];//底部自己头像
    self.myNameLabel.text = _model.user.nickname ? _model.user.nickname : @"";//底部用户昵称
    self.myScoreLabel.text = _model.user.winsPoint ? _model.user.winsPoint : @"";//底部用户自己评分
//    if (_model.user.winsPoint && ![_model.user.winsPoint isEqualToString:@""]) {
//        [self mutableAttributeSting:_model.user.winsPoint];
//    }else{
//        [self mutableAttributeSting:@"0"];
//    }
}

//任务评分赋值
- (void)scoreViewLoadData{

    if (_model.task.statusGot == 1) {//可领取
        
        [_giftBtn setBackgroundImage:[UIImage imageNamed:@"img_game_gif_selected"] forState:UIControlStateNormal];
        self.scoreBackview.hidden = NO;
        self.scoreBroughtOutLabel.hidden = YES;
        self.giftTopImage.hidden = NO;
        [self shakingAnimation];//礼物btn开始抖动
        
    }else if(_model.task.statusGot == -1){//已领完
        
        [_giftBtn setBackgroundImage:[UIImage imageNamed:@"img_game_gif_normal"] forState:UIControlStateNormal];
        self.scoreBackview.hidden = YES;
        self.scoreBroughtOutLabel.hidden = NO;
        self.giftTopImage.hidden = YES;
    }else if (_model.task.statusGot == 0){//不可领取
        
        [_giftBtn setBackgroundImage:[UIImage imageNamed:@"img_game_gif_normal"] forState:UIControlStateNormal];
        self.scoreBackview.hidden = NO;
        self.scoreBroughtOutLabel.hidden = YES;
        self.giftTopImage.hidden = YES;
    }
    
    if (!_model.task.currentCompleted || _model.task.currentCompleted == 0 || _model.task.currentCompleted == 3) {
        [self.giftBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    }else{
        [self.giftBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",_model.task.currentCompleted,_model.task.totalCompleted] forState:UIControlStateNormal];
    }
    
    for (UIView *socre in self.scoreBackview.subviews) {
        
        UIButton *btn = [self.scoreBackview viewWithTag:socre.tag];
        
        switch (socre.tag) {
            case 100:
            {
                if (_model.task.currentCompleted >= 1) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"img_game_star_selected"] forState:UIControlStateNormal];
                }else{
                    [btn setBackgroundImage:[UIImage imageNamed:@"img_game_star_normal"] forState:UIControlStateNormal];
                }
            }
                break;
                
            case 101:
            {
                if (_model.task.currentCompleted >= 2) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"img_game_star_selected"] forState:UIControlStateNormal];
                }else{
                    [btn setBackgroundImage:[UIImage imageNamed:@"img_game_star_normal"] forState:UIControlStateNormal];
                }
            }
                break;
                
            case 102:
            {
                if (_model.task.currentCompleted >= 3) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"img_game_star_selected"] forState:UIControlStateNormal];
                }else{
                    [btn setBackgroundImage:[UIImage imageNamed:@"img_game_star_normal"] forState:UIControlStateNormal];
                }
            }
                break;
                
            default:
                break;
        }
    }
    
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
    self.myScoreLabel.attributedText = attrString;
}

- (BOOL)isNotEmpty:(NSDictionary *)dic {
    return dic && [dic isKindOfClass:[NSDictionary class]] && [[dic allKeys] count] > 0;
}
//背景view
- (void)initBackView{
    
    [self.view addSubview:self.backImage];//背景view
    
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
        make.edges.equalTo(self.view).insets(inset);
    }];
}

//导航栏
- (void)initNavView{
    
    [self.backImage addSubview:self.navView];//导航栏
    [self.navView addSubview:self.navLeftBtn];
    [self.navView addSubview:self.navRightBtn];
    [self.navView addSubview:self.navTitleLabel];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(_navHeight);
    }];
    
    [self.navLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.navRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.navLeftBtn.mas_right).with.offset(5);
        make.right.mas_equalTo(self.navRightBtn.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(self.navLeftBtn.mas_centerY);
    }];

}

//窗口view、邀请好友btn、开始匹配btn；
- (void)initwindowView{
    
    [self.backImage addSubview:self.windowImage];//窗口view
    [self.backImage addSubview:self.friendBtn];//邀请好友
    [self.backImage addSubview:self.starMatch];//开始匹配
    
    [self.windowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_navView.mas_bottom).with.offset(-10);
        make.centerX.mas_equalTo(self.backImage.mas_centerX);
        make.width.mas_equalTo(340*ProportionWidth);
        make.height.mas_equalTo(487*ProportionWidth);
    }];
    
    [self.friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.windowImage.mas_bottom).with.offset(19*ProportionWidth);
        make.left.mas_equalTo(self.windowImage.mas_left);
        make.width.mas_equalTo(130*ProportionWidth);
        make.height.mas_equalTo(49*ProportionWidth);
    }];
    
    [self.starMatch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.friendBtn.mas_top);
        make.right.mas_equalTo(self.windowImage.mas_right);
        make.width.mas_equalTo(200*ProportionWidth);
        make.height.mas_equalTo(self.friendBtn);
    }];
    
    [self initWindowChildViews];//布局窗口上的子控件
}

- (void)initWindowChildViews{
    
    [self.windowImage addSubview:self.topMyIconImage];
    [self.windowImage addSubview:self.topNameLabel];
    
    [self.topMyIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55*ProportionWidth);
        make.centerX.mas_equalTo(self.windowImage.mas_centerX);
        make.width.height.mas_equalTo(90*ProportionWidth);
    }];
    
    [self.topNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topMyIconImage.mas_bottom).with.offset(8);
        make.centerX.mas_equalTo(self.windowImage.mas_centerX);
    }];
    
    [self initScoreBackview];//评分view
}

- (void)initScoreBackview{
    
    [self.windowImage addSubview:self.scoreBackview];
    
    [self.windowImage addSubview:self.scoreBroughtOutLabel];
    
    [self.windowImage addSubview:self.listTitleImage];//达人榜
    
    [self.scoreBackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topNameLabel.mas_bottom).with.offset(6*ProportionWidth);
        make.right.mas_equalTo(self.listTitleImage.mas_right);
    }];
    
    [self.scoreBroughtOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topNameLabel.mas_bottom).with.offset(6*ProportionWidth);
        make.centerX.mas_equalTo(self.windowImage.mas_centerX);
        make.height.mas_equalTo(self.scoreBackview.mas_height);
    }];
    
    CGFloat center_spacing = 21;
    CGFloat scoreWidth = 44*ProportionWidth;
    CGFloat scoreHeight = 43*ProportionWidth;

    for (int i = 0; i < scoreBtnCount; i++) {
        
        _scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scoreBtn.tag = 100 + i;
        _scoreBtn.adjustsImageWhenHighlighted = NO;
        
        [self.scoreBackview addSubview:_scoreBtn];
        
        [_scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.scoreBackview.mas_centerY);
            make.width.mas_equalTo(scoreWidth);
            make.height.mas_equalTo(scoreHeight);
            make.left.mas_equalTo((scoreWidth+center_spacing)*i);
        }];
        
    }
    
    [self.scoreBackview addSubview:self.giftBtn];
    [self.giftBtn addSubview:self.giftTopImage];
    
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_scoreBtn.mas_right).with.offset(22);
        make.width.mas_equalTo(57*ProportionWidth);
        make.height.mas_equalTo(58*ProportionWidth);
    }];
    
    [self.giftTopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.giftBtn);
        make.width.height.mas_equalTo(38*ProportionWidth);
    }];
    
    [self.listTitleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scoreBackview.mas_bottom).with.offset(12*ProportionWidth);
        make.centerX.mas_equalTo(self.windowImage.mas_centerX);
        make.width.mas_equalTo(278*ProportionWidth);
        make.height.mas_equalTo(22*ProportionWidth);
    }];
    
    [self.windowImage addSubview:self.tableView];
    
    [self.windowImage addSubview:self.bottomMyGiftView];//底部自己排名view
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.listTitleImage.mas_bottom).with.offset(3*ProportionWidth);
        make.left.mas_equalTo(self.listTitleImage.mas_left);
        make.right.mas_equalTo(self.listTitleImage.mas_right);
        make.bottom.mas_equalTo(self.bottomMyGiftView.mas_top).with.offset(-(8*ProportionWidth));
    }];
    
    [self.bottomMyGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView.mas_left);
        make.right.mas_equalTo(self.tableView.mas_right);
        make.height.mas_equalTo(65*ProportionWidth);
        make.bottom.mas_equalTo(0);
    }];
    
    [self initMyGiftView];//底部自己排名view子布局
}

- (void)initMyGiftView{
    
    [self.bottomMyGiftView addSubview:self.myTopView];
    [self.bottomMyGiftView addSubview:self.myLeftLabel];
    [self.bottomMyGiftView addSubview:self.myIconImage];
    [self.bottomMyGiftView addSubview:self.myNameLabel];
    [self.bottomMyGiftView addSubview:self.myScoreLabel];
    [self.bottomMyGiftView addSubview:self.myRightImage];
    
    [self.myTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(2*ProportionWidth);
        make.height.mas_equalTo(1);
    }];
    
    [self.myLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomMyGiftView.mas_left);
        make.centerY.mas_equalTo(self.bottomMyGiftView.mas_centerY).with.offset(-3*ProportionWidth);
        make.right.mas_equalTo(self.myIconImage.mas_left);
    }];
    
    [self.myIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomMyGiftView.mas_left).with.offset(41*ProportionWidth);
        make.centerY.mas_equalTo(self.bottomMyGiftView.mas_centerY).with.offset(-3*ProportionWidth);
        make.width.height.mas_equalTo(36*ProportionWidth);
    }];
    
    [self.myNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myIconImage.mas_right).with.offset(10*ProportionWidth);
        make.right.mas_lessThanOrEqualTo(self.myScoreLabel.mas_left).with.offset(-(5*ProportionWidth));
        make.centerY.mas_equalTo(self.bottomMyGiftView.mas_centerY).with.offset(-3*ProportionWidth);
    }];
    
    [self.myScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.myRightImage.mas_left).with.offset(5*ProportionWidth);
        make.centerY.mas_equalTo(self.bottomMyGiftView.mas_centerY).with.offset(-3*ProportionWidth);
    }];
    
    [self.myRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(8);
        make.centerY.mas_equalTo(self.bottomMyGiftView.mas_centerY).with.offset(-3*ProportionWidth);
        make.width.height.mas_equalTo(22*ProportionWidth);
    }];
    
}

-(UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] init];
        _backImage.userInteractionEnabled = YES;
        _backImage.contentMode = UIViewContentModeScaleAspectFill;
        _backImage.image = [UIImage imageNamed:@"bg_game_background"];
    }
    return _backImage;
}

-(UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] init];
        _navView.userInteractionEnabled = YES;
        _navView.backgroundColor = [UIColor clearColor];
    }
    return _navView;
}

-(UIButton *)navLeftBtn{
    if (!_navLeftBtn) {
        _navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navLeftBtn setImage:[UIImage imageNamed:@"ic_game_rules_back"] forState:UIControlStateNormal];
        [_navLeftBtn addTarget:self action:@selector(leftGoBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navLeftBtn;
}

-(UIButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navRightBtn setImage:[UIImage imageNamed:@"ic_game_rules_question_mark"] forState:UIControlStateNormal];
        [_navRightBtn addTarget:self action:@selector(theRules) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navRightBtn;
}

-(UILabel *)navTitleLabel{
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] init];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#FFFFFF"];
        _navTitleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _navTitleLabel;
}

-(UIImageView *)windowImage{
    if (!_windowImage) {
        _windowImage = [[UIImageView alloc] init];
        _windowImage.userInteractionEnabled = YES;
        _windowImage.image = [UIImage imageNamed:@"bg_game_background_ribboncard"];
    }
    return _windowImage;
}

-(UIButton *)friendBtn{
    if (!_friendBtn) {
        _friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_friendBtn setBackgroundImage:[UIImage imageNamed:@"ic_game_button_invite_friends"] forState:UIControlStateNormal];
        [_friendBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
        [_friendBtn setTitleColor:[ColorUtil cl_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_friendBtn addTarget:self action:@selector(inviteFriends) forControlEvents:UIControlEventTouchUpInside];
        _friendBtn.titleLabel.font = CZHGlobelNormalFont(18);
    }
    return _friendBtn;
}

-(UIButton *)starMatch{
    if (!_starMatch) {
        _starMatch = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starMatch setBackgroundImage:[UIImage imageNamed:@"ic_game_button_matching"] forState:UIControlStateNormal];
        [_starMatch setTitle:@"开始匹配" forState:UIControlStateNormal];
        [_starMatch setTitleColor:[ColorUtil cl_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_starMatch addTarget:self action:@selector(goMatching) forControlEvents:UIControlEventTouchUpInside];
        _starMatch.titleLabel.font = CZHGlobelNormalFont(18);
    }
    return _starMatch;
}

-(UIImageView *)topMyIconImage{
    if (!_topMyIconImage) {
        _topMyIconImage = [[UIImageView alloc] init];
        _topMyIconImage.clipsToBounds = YES;
        _topMyIconImage.layer.cornerRadius = (90*ProportionWidth)/2;
        _topMyIconImage.layer.borderWidth = 5;
        _topMyIconImage.layer.borderColor = [ColorUtil cl_colorWithHexString:@"#FECC03"].CGColor;
    }
    return _topMyIconImage;
}

-(UILabel *)topNameLabel{
    if (!_topNameLabel) {
        _topNameLabel = [[UILabel alloc] init];
        _topNameLabel.font = [UIFont boldSystemFontOfSize:CZH_ScaleFont(18)];
        _topNameLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
        _topNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topNameLabel;
}

-(UIView *)scoreBackview{
    if (!_scoreBackview) {
        _scoreBackview = [[UIView alloc] init];
    }
    return _scoreBackview;
}

-(UILabel *)scoreBroughtOutLabel{
    if (!_scoreBroughtOutLabel) {
        _scoreBroughtOutLabel = [[UILabel alloc] init];
        _scoreBroughtOutLabel.font = [UIFont systemFontOfSize:14];
        _scoreBroughtOutLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
        _scoreBroughtOutLabel.text = @"╮(╯▽╰)╭今日奖励已领完了哟～";
        _scoreBroughtOutLabel.hidden = YES;
    }
    return _scoreBroughtOutLabel;
}

-(UIButton *)giftBtn{
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _giftBtn.adjustsImageWhenHighlighted = NO;
        [_giftBtn addTarget:self action:@selector(completeGetGift) forControlEvents:UIControlEventTouchUpInside];
        _giftBtn.titleLabel.font = CZHGlobelNormalFont(15);
    }
    return _giftBtn;
}

-(UIImageView *)giftTopImage{
    if (!_giftTopImage) {
        _giftTopImage = [[UIImageView alloc] init];
        _giftTopImage.hidden = YES;
        _giftTopImage.image = [UIImage imageNamed:@"img_game_gif_selected_top"];
    }
    return _giftTopImage;
}

-(UIImageView *)listTitleImage{
    if (!_listTitleImage) {
        _listTitleImage = [[UIImageView alloc] init];
        _listTitleImage.image = [UIImage imageNamed:@"img_game_talent_list_title"];
    }
    return _listTitleImage;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[WPGGameMatchingCell class] forCellReuseIdentifier:@"WPGGameMatchingCell"];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToList)];
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

-(UIView *)bottomMyGiftView{
    if (!_bottomMyGiftView) {
        _bottomMyGiftView = [[UIView alloc] init];
        _bottomMyGiftView.userInteractionEnabled = YES;
        UITapGestureRecognizer *giftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToList)];
        [_bottomMyGiftView addGestureRecognizer:giftTap];
    }
    return _bottomMyGiftView;
}

-(UILabel *)myLeftLabel{
    if (!_myLeftLabel) {
        _myLeftLabel = [[UILabel alloc] init];
        _myLeftLabel.font = CZHGlobelNormalFont(15);
        _myLeftLabel.textAlignment = NSTextAlignmentCenter;
        _myLeftLabel.textColor = [ColorUtil cl_colorWithHexString:@"#666666"];
    }
    return _myLeftLabel;
}

-(UIImageView *)myIconImage{
    if (!_myIconImage) {
        _myIconImage = [[UIImageView alloc] init];
        _myIconImage.clipsToBounds = YES;
        _myIconImage.layer.cornerRadius = (36*ProportionWidth)/2;
    }
    return _myIconImage;
}

-(UILabel *)myNameLabel{
    if (!_myNameLabel) {
        _myNameLabel = [[UILabel alloc] init];
        _myNameLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
        _myNameLabel.font = CZHGlobelNormalFont(14);;
    }
    return _myNameLabel;
}

-(UILabel *)myScoreLabel{
    if (!_myScoreLabel) {
        _myScoreLabel = [[UILabel alloc] init];
        _myScoreLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
        _myScoreLabel.font = CZHGlobelNormalFont(15);;
    }
    return _myScoreLabel;
}

-(UIImageView *)myRightImage{
    if (!_myRightImage) {
        _myRightImage = [[UIImageView alloc] init];
        _myRightImage.image = [UIImage imageNamed:@"ic_game_rules_go"];
    }
    return _myRightImage;
}

-(UIImageView *)myTopView{
    if (!_myTopView) {
        _myTopView = [[UIImageView alloc] init];
        _myTopView.image = [UIImage imageNamed:@"img_game_talent_line"];
    }
    return _myTopView;
}

#pragma MARK -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46*ProportionWidth;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WPGGameMatchingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WPGGameMatchingCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MatchList *model = _listArray[indexPath.row];
    cell.leftLabel.text = _leftImageArray[indexPath.row];
    cell.model = model;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 进入达人榜
    // 在达人榜中需要调用 samson 的 api(按游戏来排行)
}

- (void)shakingAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(Angle2Radian(-15)), @(Angle2Radian(15)), @(Angle2Radian(-15))];
    anim.duration = 0.25;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    [self.giftTopImage.layer addAnimation:anim forKey:@"shake"];
}
//返回上页面
- (void)leftGoBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//规则
- (void)theRules{
    //self.model.gameInfo.content 游戏规则html
    
    if (self.model.gameInfo.content && ![self.model.gameInfo.content isEqualToString:@""]) {
        [WPGTheRulesView checkInViewWitWPGTheRulesViewWithwebStr:self.model.gameInfo.content];
    }
    
}

//邀请好友
- (void)inviteFriends{

    // ToDo: 可延时到用户点击分享再去请求该接口
    [self initShareData];
}
- (void)shareIconView{
    
    IDSSharedPopupConfig *sharedConfig = [[IDSSharedPopupConfig alloc] init];
    sharedConfig.title = _shareModel.data.title;
    sharedConfig.content = _shareModel.data.content;
    sharedConfig.targetUrl = _shareModel.data.url;
    sharedConfig.imgUrl = _shareModel.data.icon;
    sharedConfig.options = IDSSharedTypeQQ|IDSSharedTypeWX;
    
    [IDSSharedPopupWindow showWithConfig:sharedConfig];
}

//分享成功回调
- (void)shareSuccess{
    
    TRACK_CLICK(@"game_match", @"matching_game_intive");//数据上报
    [WPGGamePageRequest gameShareInfoCallbackRequestSuccess:^(id responseObj) {
        
    } fail:^(NSError *error) {
        
    }];
}

//开始匹配
- (void)goMatching{
    
    NSString *h5GameUrl = self.model.gameInfo.h5Url;
    if (IS_NS_STRING_EMPTY(h5GameUrl)) {
        [self initData];
    }
    else {
        TRACK_SECOND_LEVEL_CLICK(@"game_match", @"matching_game", self.ganmeId);//数据上报
        WPGH5GameController *page = [[WPGH5GameController alloc] init];
        page.gameId = self.ganmeId;
        page.gameUrl = self.model.gameInfo.h5Url;
        [self.navigationController pushViewController:page animated:NO];
    }
}

//跳转全部排行榜
- (void)goToList{

    if (!IS_NS_STRING_EMPTY(self.ganmeId)) {
        TRACK_CLICK(@"game_match", @"matching_game_ranking_list");//数据上报
        WPGSubGameRankPage *subgame = [[WPGSubGameRankPage alloc] initWithGameId:self.ganmeId];
        [self pushViewController:subgame];
    }
}

//结束礼物领取btn动画
-(void)giftBtnLayerRemoves{
    [self.giftTopImage.layer removeAllAnimations];
}

//礼物领取
- (void)completeGetGift{
    
    if (_model.task.statusGot == 1) {
        [self completeGiftData];
    }else{
        return;
    }
}
-(void)dealloc{
    [self giftBtnLayerRemoves];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//礼物领取请求
- (void)completeGiftData{
    
    [self giftBtnLayerRemoves];//结束动画
    
    [WPGGamePageRequest completeGetGiftWithGameId:self.ganmeId Success:^(id responseObj) {

        TRACK_CLICK(@"game_match", @"matching_game_openbox");//数据上报
        
        if ([self isNotEmpty:responseObj]) {
        
            WPGTaskGiftBagModel *model = [WPGTaskGiftBagModel mj_objectWithKeyValues:responseObj];
            
            _model.task.currentCompleted = model.data.currentCompleted;
            _model.task.totalCompleted = model.data.totalCompleted;
            _model.task.statusGot = model.data.statusGot;
            
            [self scoreViewLoadData];//重新给星星view赋值
            
            [WPGGiftBagWindowView checkInViewWithDynamicPopViewWithDiamindStr:model.data.cons];//领取成功弹窗
        }
        
    } fail:^(NSError *error) {

    }];
}


@end
