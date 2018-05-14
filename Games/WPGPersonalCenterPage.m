//
//  WPGPersonalCenterPage.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGPersonalCenterPage.h"
#import "WPGPersonHeaderView.h"
#import "WPGPersonalCenterCollectionViewCell.h"
#import "WPGPersonGameView.h"
#import "IDSSettingPage.h"
#import "WPGPersonCenterRequest.h"
#import "WPGProfileCenterModel.h"
#import "IDSReportH5Page.h"
#import "IDSUserRequest.h"
#import "WPGamePersonCenterBottomView.h"
#import "IDSUserRequest.h"
#import "WPGBadgePageViewController.h"
#import "WPGPersonalChatViewController.h"
#import "WPGGroupChatViewController.h"
#import "UINavigationController+IDSStack.h"
#import "BaseMainTabBarViewController.h"

static const CGFloat collectionViewHeaderHeight = 250+45;

@interface WPGPersonalCenterPage () <UICollectionViewDelegate, UICollectionViewDataSource, WPGPersonHeaderDelegate, WPGamePersonCenterBottomViewDelegate>

@property (nonatomic, strong) WPGPersonHeaderView *personHeaderView;
@property (nonatomic, strong) UICollectionView *achieveCollectionView;
@property (nonatomic, strong) UILabel *achieveCountLabel;
@property (nonatomic, strong) UIView *achieveTitleView;
@property (nonatomic, strong) UIView *gameTitleView;
@property (nonatomic, strong) WPGPersonGameView *gameView;
@property (nonatomic, strong) UIView *achieveEmptyView;
@property (nonatomic, strong) UIView *gameEmptyView;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) WPGUserinfoModel *userInfoModel;
@property (nonatomic, strong) NSMutableArray *achievementArray;
@property (nonatomic, strong) NSMutableArray *gameArray;
@property (nonatomic, assign) BOOL isMinePage;
@property (nonatomic, assign) NSInteger friendStatus;
@property (nonatomic, strong) WPGamePersonCenterBottomView *bottomView;

@end

@implementation WPGPersonalCenterPage

- (void)dealloc
{
    IDSLOG(@"WPGPersonalCenterPage dealloc");
}

- (instancetype)initWithUid:(NSString *)uid
{
    self = [super init];
    if (self) {
        _uid = uid;
        _isMinePage = NO;
        if ([_uid isEqualToString:NAccount.user.uid]) {
            _isMinePage = YES;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addUIView];
    
    IDSAddNFObserver(@selector(doUserLogoutAction:), kUserLogoutNotify);
    IDSAddNFObserver(@selector(doRefreshData), kUserLoginSuccessNotify);
    IDSAddNFObserver(@selector(updateUserAvatar:), kUserUpdateAvatar);
    IDSAddNFObserver(@selector(updateUserName:), kUserUpdateUserName);
    IDSAddNFObserver(@selector(updateUserProfile:), kUserUpdateProfile);
    IDSAddNFObserver(@selector(doRefreshData), kWPGGameUserInfoUpdateEXP);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self doRefreshData];
    
    /*
    if (![[AccountManager sharedManager] isVisitor]) {
        [self doRefreshData];
    }
     */
    
    [self.personHeaderView makeAnimitionVoid];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)preferredNavigationBarHidden
{
    return YES;
}

- (void)addUIView
{
    _achievementArray = [NSMutableArray new];
    _gameArray = [NSMutableArray new];
    [self.view addSubview:self.achieveCollectionView];
    [self.achieveCollectionView addSubview:self.personHeaderView];
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 245+4, SCREEN_WIDTH, 22+20)];
    upView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FBFAFF"];
    upView.layer.masksToBounds = YES;
    [self.achieveCollectionView addSubview:upView];
    [upView addSubview:self.achieveTitleView];
    
    UIBezierPath *maskPathA = [UIBezierPath bezierPathWithRoundedRect:upView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayerA = [[CAShapeLayer alloc] init];
    maskLayerA.frame = upView.bounds;
    maskLayerA.path = maskPathA.CGPath;
    upView.layer.mask = maskLayerA;
    upView.layer.masksToBounds = YES;
    
    self.achieveTitleView.frame = CGRectMake(0, 22, SCREEN_WIDTH, 20);
    [self.achieveCollectionView addSubview:self.gameView];
    [self.achieveCollectionView addSubview:self.gameTitleView];
    [self.achieveCollectionView addSubview:self.gameView];
    [self.achieveCollectionView addSubview:self.achieveEmptyView];
    [self.achieveCollectionView addSubview:self.gameEmptyView];
    self.achieveEmptyView.hidden = YES;
    self.gameEmptyView.hidden = YES;
    
    [self.achieveCollectionView registerClass:[WPGPersonalCenterCollectionViewCell class] forCellWithReuseIdentifier:@"WPGPersonalCenterCollectionViewCell"];
    [self.view addSubview:self.achieveCollectionView];
    MJRefreshHeader *header = [IDSRefresh headerWithRefreshingTarget:self
                                                    refreshingAction:@selector(doRefreshData)];
    self.achieveCollectionView.mj_header = header;
    
    if (!_isMinePage) {
        [self.view addSubview:self.bottomView];
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-55, SCREEN_WIDTH, 55);
        self.achieveCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-55);
        [self.bottomView.layer setShadowColor:NF_Color_C25.CGColor];
        self.bottomView.layer.contentsScale = [UIScreen mainScreen].scale;
        self.bottomView.layer.shadowOpacity = 0.02f;
        self.bottomView.layer.shadowRadius = 4.0f;
        self.bottomView.layer.shadowOffset = CGSizeMake(0.0,-4.0);
        self.bottomView.layer.masksToBounds = NO;
    }
    else {
        self.achieveCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapAvatarAction:)];
    self.personHeaderView.avatarImageView.userInteractionEnabled = YES;
    [self.personHeaderView.avatarImageView addGestureRecognizer:gesture];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}

- (void)doRefreshData
{
    if (_isMinePage) {
        _uid = NAccount.user.uid;
    }
    [self dataRequest];
    [self dataRequestAboutAchievement];
}

- (void)dataRequest
{
    if ([[AccountManager sharedManager] isVisitor]) {
        return;
    }
    
    @weakify(self);
    [WPGPersonCenterRequest personCenterRequestWithUid:_uid Success:^(id responseObj) {
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            
            WPGProfileCenterModel *model = [WPGProfileCenterModel mj_objectWithKeyValues:responseData.data];
            if (model.userInfo) {
                
                NSString *curUid = [NSString stringWithFormat:@"%zd", model.userInfo.uid];
                if (![[AccountManager sharedManager] isMySelf:curUid]) {
//                    IDSPostNF(kReviewUserProfile);
                    IDSPostNFWithObj(kReviewUserProfile, curUid);
                }
                
                _userInfoModel = model.userInfo;
                [self addProfileData];
            }
        }
        else {
            [self warnUser:responseData.msg];
        }
        
    } fail:^(NSError *error) {
        @strongify(self);
        [self removeLoading];
        if (!_userInfoModel) {
            [self warnUser:@"网络拉取失败呦，请重新试试呢？"];
        }
    }];
}

- (void)dataRequestAboutAchievement
{
    if ([[AccountManager sharedManager] isVisitor]) {
        return;
    }
    
    @weakify(self);
    [WPGPersonCenterRequest personCenterAchieveArrayRequestWithUid:_uid Success:^(id responseObj) {
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            WPGUserAchievementModel *achievementModel = [WPGUserAchievementModel mj_objectWithKeyValues:responseData.data];
            int achievementCount = 0;
            
            if (achievementModel.achv) {
                [_achievementArray removeAllObjects];
                for (WPGAchieveMentListModel *model in achievementModel.achv) {
                    if (model.status == 2) ++achievementCount;
                    [_achievementArray cl_addObject:model];
                }
            }
            if (achievementModel.game) {
                [_gameArray removeAllObjects];
                for (WPGameListModel *model in achievementModel.game) {
                    [_gameArray cl_addObject:model];
                }
                [self.gameView loadDataWithModel:_gameArray];
            }
            _friendStatus = achievementModel.friendStatus.integerValue;
            [self.bottomView dataWithFriendStatus:achievementModel.friendStatus.integerValue];
            
            [self.achieveCollectionView reloadData];
            if (_isMinePage) {
                _achieveCountLabel.text = [NSString stringWithFormat:@"(%@/9)",@(achievementCount)];
            }
            else {
                _achieveCountLabel.text = [NSString stringWithFormat:@"(%@)",@(_achievementArray.count)];
            }
        }
        else {
            [self warnUser:responseData.msg];
        }
        [self.achieveCollectionView.mj_header endRefreshing];
    } fail:^(NSError *error) {
        @strongify(self);
        [self removeLoading];
        if (!_achievementArray.count && !_gameArray.count) {
            [self warnUser:@"网络拉取失败呦，请重新试试呢？"];
        }
        [self.achieveCollectionView.mj_header endRefreshing];
    }];
}

- (void)addProfileData
{
    if (!_userInfoModel) {
        return;
    }
    [self.personHeaderView addDataWithModel:_userInfoModel];
    if (_userInfoModel.uid == NAccount.user.uid.integerValue) {
        NAccount.user.level = (int)_userInfoModel.level;
        NAccount.user.username = _userInfoModel.nickname;
        NAccount.user.gender = (int)_userInfoModel.gender;
        NAccount.user.age = (int)_userInfoModel.age;
    }
}

- (void)doUserLogoutAction:(id)sender
{
    IDSPerformBlockOnMainThreadAfterDelay(0.05f, ^{
        [self openLoginPage:YES];
    });
}

- (void)updateUserAvatar:(id)sender
{
    if ([self.uid isEqualToString:NAccount.user.uid]) {
        
        UIImage *defImg = [IDSImageManager defaultAvatar:CircleStyle];
        NSURL *url = [AppUtil urlEncodeToNSURL:NAccount.user.avatar_url];
        [self.personHeaderView.avatarImageView sd_setImageWithURL:url
                                                 placeholderImage:defImg
                                                          options:SDWebImageRetryFailed|SDWebImageLowPriority];
    }
}

- (void)updateUserName:(id)sender
{
    if ([self.uid isEqualToString:NAccount.user.uid]) {
        
        self.userInfoModel.nickname = NAccount.user.username;
        self.userInfoModel.province = NAccount.user.province;
        self.userInfoModel.city = NAccount.user.city;
        [self.personHeaderView addDataWithModel:self.userInfoModel];
    }
}

- (void)updateUserProfile:(id)sender
{
    if ([self.uid isEqualToString:NAccount.user.uid]) {
        [self.personHeaderView.genderNamedView gender:NAccount.user.gender age:NAccount.user.age];
    }
    [self.personHeaderView adjustMineViewFrame];
}

- (void)appDidBecomActive:(NSNotification *)sender
{
    [self.personHeaderView makeAnimitionVoid];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _achievementArray.count?:0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSUInteger gameNum = _gameArray.count;
    NSUInteger badgeNum = _achievementArray.count;
    self.gameEmptyView.hidden = YES;
    self.achieveEmptyView.hidden = YES;

    if (!badgeNum) {
        self.achieveEmptyView.hidden = NO;
        self.achieveEmptyView.frame = CGRectMake(0, collectionViewHeaderHeight, SCREEN_WIDTH, 136);
        self.gameTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.achieveEmptyView.frame), SCREEN_WIDTH, 20);
        self.gameView.frame = CGRectMake(0, CGRectGetMaxY(self.gameTitleView.frame)+10, SCREEN_WIDTH, 75);
    }
    else {
        self.gameTitleView.frame = CGRectMake(0, collectionViewHeaderHeight+(ceilf(badgeNum/3.0)*136+
                                                                             (ceilf(badgeNum/3.0)-1)*4)+16, SCREEN_WIDTH, 20);
        self.gameView.frame = CGRectMake(0, CGRectGetMaxY(self.gameTitleView.frame)+10, SCREEN_WIDTH, 75);
    }
    
    if (!gameNum) {
        self.gameEmptyView.hidden = NO;
        self.gameEmptyView.frame = CGRectMake(0, CGRectGetMaxY(self.gameTitleView.frame), SCREEN_WIDTH, 136);
        return UIEdgeInsetsMake(collectionViewHeaderHeight, (SCREEN_WIDTH-3*111)*1/3.0, CGRectGetMaxY(self.gameEmptyView.frame)-CGRectGetMinY(self.gameTitleView.frame), (SCREEN_WIDTH-3*111)*1/3.0);
    }
    else {
        return UIEdgeInsetsMake(collectionViewHeaderHeight, (SCREEN_WIDTH-3*111)*1/3.0, 47+CGRectGetMaxY(self.gameView.frame)-CGRectGetMinY(self.gameTitleView.frame), (SCREEN_WIDTH-3*111)*1/3.0);
    }
    
    return UIEdgeInsetsMake(collectionViewHeaderHeight, (SCREEN_WIDTH-3*111)*1/3.0, 47+CGRectGetMaxY(self.gameView.frame)-CGRectGetMinY(self.gameTitleView.frame), (SCREEN_WIDTH-3*111)*1/3.0);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(111, 136);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGPersonalCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPGPersonalCenterCollectionViewCell" forIndexPath:indexPath];
    
    WPGAchieveMentListModel *achieveListModel = [_achievementArray cl_objectAtIndex:indexPath.row];
    [cell cellWithData:achieveListModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGBadgePageViewController *pageVc = [[WPGBadgePageViewController alloc] init];
    WPGAchieveMentListModel *achieveListModel = [_achievementArray cl_objectAtIndex:indexPath.row];
    [pageVc initWithData:achieveListModel isMine:_isMinePage];
    [self pushViewController:pageVc];
}

- (void)addFriendAction:(WPGamePersonCenterBottomView *)personCenterView
{
    @weakify(self);
    [WPGPersonCenterRequest requestAddFriendWithUid:_uid Success:^(id responseObj) {
        @strongify(self);
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            [self warnUser:@"已发送好友请求."];
        }
        else {
            [self warnUser:responseData.msg];
        }
    } fail:^(NSError *error) {
        @strongify(self);
        [self removeLoading];
        [self warnUser:@"网络拉取失败呦，请重新试试呢？"];
    }];
}

- (void)chatAction:(WPGamePersonCenterBottomView *)personCenterView
{
    int flag = 0;
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[WPGGroupChatViewController class]]) {
            [marr removeObject:vc];
            flag = 1;
            break;
        }
        
        if ([vc isKindOfClass:[WPGPersonalChatViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    if (flag) {
        self.navigationController.viewControllers = marr;
    }
    WPGPersonalChatViewController *chatViewCortroller = [[WPGPersonalChatViewController alloc] initWithChatEachOtherUID:_uid];
    [self pushViewController:chatViewCortroller];
}

- (void)clickLeftBtnAction:(WPGPersonHeaderView *)personHeaderView
{
    [self goBack];
}

- (void)clickRightBtnAction:(WPGPersonHeaderView *)personHeaderView
{
    if (_isMinePage) {
        IDSSettingPage *settingPage = [[IDSSettingPage alloc] init];
        [self pushViewController:settingPage];
    }
    else {
        [self doReportAction];
    }
}

- (void)doReportAction
{
    NSArray *butnTitles;
    if (_friendStatus == 3) {
        butnTitles = @[@"投诉", @"移出黑名单", @"取消"];
    }
    else {
        butnTitles = @[@"投诉", @"拉黑", @"取消"];
    }
    
    @weakify(self);
    [DialogHelper showDialog:@"" buttonTitles:butnTitles block:^(NSInteger index, IDSAlertSheet *sheet) {
        
        @strongify(self);
        if (1 == index) {
            
            IDSReportH5Page *page = [[IDSReportH5Page alloc] init];
            page.moduleType = IDSReportH5PageTypeUser;
            page.relate_id = _uid;
            TRACK_SECOND_LEVEL_CLICK(@"profile", @"Complaint", nil);
            [self pushViewController:page];
        }
        else if (2 == index) {
            
            if ([[AccountManager sharedManager] isVisitor]) {
                [self openLoginPage:YES];
                return;
            }
            
            @weakify(self);
            if (_friendStatus == 3) {
                [IDSUserRequest requestPullBlackUser:_uid status:@"0" success:^(id responseObj) {
                    @strongify(self);
                    IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
                    if ([responseData isResponseOK]) {
                        [self warnUser:@"移出黑名单成功！"];
                        [self dataRequestAboutAchievement];
                        //[self.bottomView dataWithFriendStatus:_friendStatus];
                    }
                } fail:^(NSError *error) {
                    @strongify(self);
                    [self warnUser:@"网络请求有误，请重试！"];
                }];
            }
            else {
                
                @weakify(self);
                [DialogHelper showPullBlockUserDialog:^(UIAlertAction *action) {
                    
                    @strongify(self);
                    [self doReqPullBlockUserAction];
                    _friendStatus = 4;
                    [self.bottomView dataWithFriendStatus:_friendStatus];
                } cancelAction:^(UIAlertAction *action) {
                    
                }];
            }
        }
        else {
            [sheet dismiss];
        }
    }].outerSideCanCancel = YES;
}

- (void)doReqPullBlockUserAction
{
    @weakify(self);
    [IDSUserRequest requestPullBlackUser:_uid status:@"1" success:^(id responseObj) {
        @strongify(self);
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            [self warnUser:@"拉黑成功！"];
            _friendStatus = 3;
            TRACK_SECOND_LEVEL_CLICK(@"profile", @"blacklist", nil);
        }
        else {
            [self warnUser:responseData.msg];
        }
    } fail:^(NSError *error) {
        @strongify(self);
        [self warnUser:@"网络请求有误，请重试！"];
    }];
}

- (void)doTapAvatarAction:(UIGestureRecognizer *)gesture
{
    NSString *avatarURL = _userInfoModel.avatar;
    if (IS_NS_STRING_EMPTY(avatarURL)) {
        return;
    }
    
    UIImageView *imgView = (UIImageView *)gesture.view;
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.srcImageView = imgView;
    photo.url = [AppUtil urlEncodeToNSURL:avatarURL];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = [NSArray arrayWithObject:photo];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [imgView convertRect:imgView.bounds toView:window];
    browser.beginRect = rect;
    [browser show];
}

#pragma mark - lazy loading...

- (WPGPersonHeaderView *)personHeaderView
{
    if (!_personHeaderView) {
        _personHeaderView = [[WPGPersonHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 253) WithMineCenter:_isMinePage];
        _personHeaderView.delegate = self;
    }
    return _personHeaderView;
}

- (UILabel *)achieveCountLabel
{
    if (!_achieveCountLabel) {
        _achieveCountLabel = [[UILabel alloc] init];
        _achieveCountLabel.text = @"(0/9)";
        _achieveCountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _achieveCountLabel.textColor = [ColorUtil cl_colorWithHexString:@"#999999"];
    }
    return _achieveCountLabel;
}

- (UICollectionView *)achieveCollectionView
{
    if (!_achieveCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //layout.sectionInset = UIEdgeInsetsMake(collectionViewHeaderHeight, (SCREEN_WIDTH-3*111)*1/3.0, 10, (SCREEN_WIDTH-3*111)*1/3.0);
        // cell 左右间距
        layout.minimumInteritemSpacing = (SCREEN_WIDTH-3*111)/6.0;
        // cell 上下间距
        layout.minimumLineSpacing = 4;
        
        _achieveCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _achieveCollectionView.delegate = self;
        _achieveCollectionView.dataSource = self;
        _achieveCollectionView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FBFAFF"];
        _achieveCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _achieveCollectionView;
}

- (UIView *)achieveTitleView
{
    if (!_achieveTitleView) {
        _achieveTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        UIView *sectionTitle = [[UIView alloc] init];
        sectionTitle.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(23, 0, 0, 0);
        if (_isMinePage) {
            titleLabel.text = @"我的成就";
        }
        else {
            titleLabel.text = @"TA的成就";
        }
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        titleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
        [titleLabel sizeToFit];
        
        UIView *titleView = [[UIView alloc] init];
        titleView.frame = CGRectMake(15, 0, 3, 15);
        titleView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
        titleView.layer.cornerRadius = 1.5f;
        titleView.layer.masksToBounds = YES;
        titleView.centerY = titleLabel.centerY;
        self.achieveCountLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)+2, 0, 0, 0);
        [self.achieveCountLabel sizeToFit];
        self.achieveCountLabel.centerY = titleLabel.centerY;
        [_achieveTitleView addSubview:titleView];
        [_achieveTitleView addSubview:titleLabel];
        [_achieveTitleView addSubview:self.achieveCountLabel];
        _achieveTitleView.frame = CGRectMake(0, 17+250, SCREEN_WIDTH, 20);
    }
    return _achieveTitleView;
}

- (UIView *)gameTitleView
{
    if (!_gameTitleView) {
        _gameTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        UIView *sectionTitle = [[UIView alloc] init];
        sectionTitle.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(23, 0, 0, 0);
        titleLabel.text = @"常玩游戏";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        titleLabel.textColor = [ColorUtil cl_colorWithHexString:@"#333333"];
        [titleLabel sizeToFit];
        
        UIView *titleView = [[UIView alloc] init];
        titleView.frame = CGRectMake(15, 0, 3, 15);
        titleView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
        titleView.layer.cornerRadius = 1.5f;
        titleView.layer.masksToBounds = YES;
        titleView.centerY = titleLabel.centerY;
        
        [_gameTitleView addSubview:titleView];
        [_gameTitleView addSubview:titleLabel];
        _gameTitleView.frame = CGRectMake(0, collectionViewHeaderHeight+136*3+4*2+16, SCREEN_WIDTH, 20);

    }
    return _gameTitleView;
}

- (WPGPersonGameView *)gameView
{
    if (!_gameView) {
        _gameView = [[WPGPersonGameView alloc] init];
    }
    return _gameView;
}

- (UIView *)achieveEmptyView
{
    if (!_achieveEmptyView) {
        _achieveEmptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 136)];
        UILabel *emptyLabel = [[UILabel alloc] init];
        emptyLabel.text = @"╮(╯▽╰)╭ 还木有成就诶～";
        emptyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        emptyLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
        [emptyLabel sizeToFit];
        emptyLabel.centerX = _achieveEmptyView.bounds.size.width / 2.0;
        emptyLabel.centerY = _achieveEmptyView.bounds.size.height / 2.0;
        [_achieveEmptyView addSubview:emptyLabel];
    }
    return _achieveEmptyView;
}

- (UIView *)gameEmptyView
{
    if (!_gameEmptyView) {
        _gameEmptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 76)];
        UILabel *emptyLabel = [[UILabel alloc] init];
        emptyLabel.text = @"╮(╯▽╰)╭ 还木有玩过游戏～";
        emptyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        emptyLabel.textColor = [ColorUtil cl_colorWithHexString:@"#CCCCCC"];
        [emptyLabel sizeToFit];
        emptyLabel.centerX = _gameEmptyView.bounds.size.width / 2.0;
        emptyLabel.centerY = _gameEmptyView.bounds.size.height / 2.0;
        [_gameEmptyView addSubview:emptyLabel];
    }
    return _gameEmptyView;
}

- (WPGamePersonCenterBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[WPGamePersonCenterBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-55, SCREEN_WIDTH, 55)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

@end
