//
//  WPGGameTableController.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/9.
//  Copyright © 2018 WePlay. All rights reserved.
//

#import "WPGGameTableController.h"
#import "WPGGamePageHeaderImageView.h"
#import "WPGEveryTaskAndActivity.h"
#import "WPGGameCollectionViewCell.h"
#import "WPGGamePageRequest.h"
#import "IDSRefresh.h"
#import "WPGGamePageModel.h"
#import "WPGameRankMainPage.h"
#import "WPGamePageEveryDayTask.h"
#import "WPGPersonalCenterPage.h"
#import "WPGGameMatchingVC.h"
#import "WPGSubGameRankPage.h"
#import "WPGUserInfoHeard.h"
#import "WPGSayHiView.h"

@interface WPGGameTableController () <UICollectionViewDelegate, UICollectionViewDataSource, WPGGamePageHeaderImageViewDelegate, WPGEveryTaskAndActivityDelegate, WPGUserInfoDelegate>

// 头部View
@property (nonatomic, strong) UIView *tableheaderView;
// 游戏列表上方的排行榜模块
@property (nonatomic, strong) WPGGamePageHeaderImageView *gameHeaderView;
// 排行榜下方的任务限时活动模块
@property (nonatomic, strong) UIView *gameContentView;
// 每日任务
@property (nonatomic, strong) WPGEveryTaskAndActivity *everyTaskView;
@property (nonatomic, strong) UICollectionView *gameCollectionView;
// 排名数组
@property (nonatomic, strong) NSMutableArray *rankArray;
// 游戏数组
@property (nonatomic, strong) NSMutableArray *gameArray;

@property (nonatomic, strong) WPGUserInfoHeard *userInfoHeard;

@property (nonatomic, strong) UIView *topView;

@end

@implementation WPGGameTableController

- (void)dealloc
{
    IDSLOG(@"WPGGameTableController realease");
}

- (void)releaseSelf
{
    IDSRemoveNFObserver(kUserLoginSuccessNotify);
    IDSRemoveNFObserver(kUserUpdateProfile);
    IDSRemoveNFObserver(kWPGGameUserInfoUpdateUserCoins);
    IDSRemoveNFObserver(kWPGGameUserInfoUpdateEXP);
    IDSRemoveNFAllObservers(self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithView];
    //self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.gameCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.view.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7F6DEF"];
    IDSAddNFObserver(@selector(userHeardUpDate), kUserLoginSuccessNotify);
    IDSAddNFObserver(@selector(userHeardUpDate), kUserUpdateProfile);
    IDSAddNFObserver(@selector(userHeardUpDate), kWPGGameUserInfoUpdateUserCoins);
    IDSAddNFObserver(@selector(userHeadUpDate:), kWPGGameUserInfoUpdateEXP);

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self dataRequest];
    [self userHeardUpDate];
}

-(BOOL)preferredNavigationBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (NSInteger)currentTabBarIndex
{
    return 0;
}

- (void)initWithView
{
    _rankArray = [NSMutableArray new];
    _gameArray = [NSMutableArray new];
    
    [self.gameCollectionView registerClass:[WPGGameCollectionViewCell class] forCellWithReuseIdentifier:@"WPGGameCollectionViewCell"];
    [self.view addSubview:self.gameCollectionView];
    self.gameCollectionView.alwaysBounceVertical = NO;
    [self.gameCollectionView addSubview:self.tableheaderView];
    [self.tableheaderView addSubview:self.gameHeaderView];
    [self.tableheaderView addSubview:self.gameContentView];
    //[self.gameContentView addSubview:self.everyTaskView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.userInfoHeard];
    self.gameContentView.backgroundColor = NF_Color_C1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableheaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.gameContentView.frame));
    self.tableheaderView.layer.masksToBounds = YES;
    self.tableheaderView.clipsToBounds = YES;
}

- (void)addSectionTitleView
{
    UIView *sectionTitle = [[UIView alloc] init];
    sectionTitle.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(23, 0, 0, 0);
    titleLabel.text = @"一起玩游戏";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    titleLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [titleLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(15, 0, 3, 15);
    titleView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    titleView.layer.cornerRadius = 1.5f;
    titleView.layer.masksToBounds = YES;
    
    [sectionTitle addSubview:titleView];
    [sectionTitle addSubview:titleLabel];
    sectionTitle.frame = CGRectMake(0, 80, SCREEN_WIDTH, titleLabel.size.height);
    titleView.centerY = titleLabel.size.height/2.0;
    [self.gameContentView addSubview:sectionTitle];
    self.gameContentView.frame = CGRectMake(0, 245, SCREEN_WIDTH, CGRectGetMaxY(sectionTitle.frame));
    self.tableheaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.gameContentView.frame));
    self.tableheaderView.layer.masksToBounds = YES;
    self.tableheaderView.clipsToBounds = YES;
    self.gameContentView.layer.masksToBounds = YES;
    self.gameContentView.clipsToBounds = YES;
}

- (void)userHeardUpDate
{
    [self.userInfoHeard fullViewWithModel];
}

// 经验升级
- (void)userHeadUpDate:(NSNotification *)sender
{
    NSDictionary *dic = sender.userInfo;
    NSString *up = [dic objectForKey:kWPGGameUserInfoUpdateEXPKeyUp];
    if (up.integerValue) {
        [self.userInfoHeard levelIncreaseAnimation];
    }
    else {
        [self.userInfoHeard levelUpAnimation];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gameArray.count?:0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGGamePageGames *model = [self.gameArray cl_objectAtIndex:indexPath.row];
    if (model.type == 0) {
        return CGSizeMake(SCREEN_WIDTH-30, 100);
    }
    else {
        return CGSizeMake((SCREEN_WIDTH-40)/2.0, 100);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPGGameCollectionViewCell" forIndexPath:indexPath];
    WPGGamePageGames *model = [self.gameArray cl_objectAtIndex:indexPath.row];
    [cell cellWithData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGGamePageGames *model = [self.gameArray cl_objectAtIndex:indexPath.row];
    TRACK_SECOND_LEVEL_CLICK(@"game", @"choose_game", model.gameId);
    WPGGameMatchingVC *matching = [[WPGGameMatchingVC alloc] initWithGameId:model.gameId gameName:model.name];
    [self pushViewController:matching];
}

- (void)openRankPage:(WPGGamePageHeaderImageView *)gamePageHeaderImageView
{
    WPGameRankMainPage *page = [[WPGameRankMainPage alloc] init];
    [self pushViewController:page];
}

- (void)openEveryTaskPage:(WPGEveryTaskAndActivity *)everyTaskView
{
    WPGamePageEveryDayTask *taskView = [[WPGamePageEveryDayTask alloc] initWithId:1];
    [self pushViewController:taskView];
}

- (void)openActivityPage:(WPGEveryTaskAndActivity *)everyTaskView
{
    
//    WPGSubGameRankPage *subgame = [[WPGSubGameRankPage alloc] initWithGameId:@"1"];
//    [self pushViewController:subgame];
    WPGamePageEveryDayTask *taskView = [[WPGamePageEveryDayTask alloc] initWithId:2];
    [self pushViewController:taskView];
}

- (void)WPGUserInfoViewTouchHeard
{
    TRACK_CLICK(@"ranking", @"rankinglist_into_my_profile");
    [self openUserProfile:NAccount.user.uid];
}

#pragma mark - Network Request.

- (void)dataRequest
{
    @weakify(self);
    [WPGGamePageRequest GameHomeRequestSuccess:^(id responseObj) {
        @strongify(self);
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            WPGGamePageModel *model = [WPGGamePageModel mj_objectWithKeyValues:responseData.data];
            if (model.ranking) {
                [_rankArray removeAllObjects];
                for (WPGGamePageRanking *rankModel in model.ranking) {
                    [_rankArray cl_addObject:rankModel];
                }
            }
            if (model.games) {
                [_gameArray removeAllObjects];
                for (WPGGamePageGames *gameModel in model.games) {
                    [_gameArray cl_addObject:gameModel];
                }
            }
            [self addData];
        }
        else {
            [self warnUser:responseData.msg];
        }
    } fail:^(NSError *error) {
        @strongify(self);
        [self removeLoading];
        
        if (!_rankArray.count) {
            [self warnUser:@"网络拉取失败呦，请重新试试呢？"];
        }
    }];
}

- (void)dataRequestAboutTaskRedView
{
    @weakify(self);
    [WPGGamePageRequest gameRequestRedViewSuccess:^(id responseObj) {
        @strongify(self);
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            WPGGetRedNewTaskModel *model = [WPGGetRedNewTaskModel mj_objectWithKeyValues:responseData.data];
            self.everyTaskView.redViewA.hidden = model.dailyCount?NO:YES;
            self.everyTaskView.redViewB.hidden = model.actvityCount?NO:YES;
        }
    } fail:^(NSError *error) {
        @strongify(self);
        [self removeLoading];
    }];
}

- (void)addData
{
    [self.gameHeaderView addDataWithArray:self.rankArray];
    [self.gameCollectionView reloadData];
}

- (void)openProfile
{
    [self openUserProfile:NAccount.user.uid];
}

#pragma mark - lazy loading.

- (WPGGamePageHeaderImageView *)gameHeaderView
{
    if (!_gameHeaderView) {
        _gameHeaderView = [[WPGGamePageHeaderImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
        _gameHeaderView.delegate = self;
    }
    return _gameHeaderView;
}

- (UIView *)tableheaderView
{
    if (!_tableheaderView) {
        _tableheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260+64)];
    }
    return _tableheaderView;
}

- (UIView *)gameContentView
{
    if (!_gameContentView) {
        _gameContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 245, SCREEN_WIDTH, 16)];
        _gameContentView.backgroundColor = [UIColor whiteColor];
        // 上半部有圆角，下半部没有圆角
        UIBezierPath *maskPathA = [UIBezierPath bezierPathWithRoundedRect:_gameContentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayerA = [[CAShapeLayer alloc] init];
        maskLayerA.frame = _gameContentView.bounds;
        maskLayerA.path = maskPathA.CGPath;
        _gameContentView.layer.mask = maskLayerA;
        _gameContentView.layer.masksToBounds = YES;
    }
    return _gameContentView;
}

- (WPGEveryTaskAndActivity *)everyTaskView
{
    if (!_everyTaskView) {
        _everyTaskView = [[WPGEveryTaskAndActivity alloc] init];
        _everyTaskView.frame = CGRectMake(0, 15, SCREEN_WIDTH, 50);
        _everyTaskView.delegate = self;
    }
    return _everyTaskView;
}

- (UICollectionView *)gameCollectionView
{
    if (!_gameCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(253+8, 15, 10, 15);
        // cell 上下间距
        layout.minimumInteritemSpacing = 10;
        // cell 间距
        layout.minimumLineSpacing = 10;
        _gameCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-48) collectionViewLayout:layout];
        if (IS_IPHONE_X) {
            _gameCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-48-32);
        }
        
        _gameCollectionView.delegate = self;
        _gameCollectionView.dataSource = self;
        _gameCollectionView.showsVerticalScrollIndicator = NO;
        _gameCollectionView.showsHorizontalScrollIndicator = NO;
        _gameCollectionView.backgroundColor = [UIColor whiteColor];
        _gameCollectionView.layer.masksToBounds = YES;
        _gameCollectionView.clipsToBounds = YES;
    }
    return _gameCollectionView;
}

- (WPGUserInfoHeard *)userInfoHeard
{
    if (!_userInfoHeard) {
        _userInfoHeard = [[WPGUserInfoHeard alloc] initWithFrame:CGRectMake(0, -10, SCREEN_WIDTH, 74)];
        if (IS_IPHONE_X) {
            _userInfoHeard.frame = CGRectMake(0, 10, SCREEN_WIDTH, 74);
        }
        _userInfoHeard.delegate = self;
        [_userInfoHeard fullViewWithModel];
    }
    return _userInfoHeard;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, SCREEN_WIDTH, 74)];
        if (IS_IPHONE_X) {
            _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 74+20);
        }
        _topView.alpha = 0;
        _topView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#7F6DEF"];
    }
    return _topView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 处理导航栏
    CGFloat distY = scrollView.contentOffset.y;
    [self animateByOffsetY:distY];
    if (scrollView.contentOffset.y <= 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}

- (void)animateByOffsetY:(CGFloat)offsety
{
    CGFloat fitHeight = 156/2.0;
    _topView.alpha = offsety/fitHeight;
}

@end
