//
//  WPGSubGameRankPage.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/24.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGSubGameRankPage.h"
#import "WPGGamePageRequest.h"
#import "WPGGamePageModel.h"
#import "WPGRankBottomView.h"
#import "WPGPlayRankCollectionViewCell.h"
#import "WPGRuleView.h"

@interface WPGSubGameRankPage () <UICollectionViewDelegate, UICollectionViewDataSource, WPGRuleViewDelegate, WPGPlayRankCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *rankCollectionView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) WPGRankBottomView *rankBottomView;
@property (nonatomic, strong) NSMutableArray *rankArray;
@property (nonatomic, strong) WPGGamePageMyRank *myrankModel;
@property (nonatomic, strong) WPGRuleView *ruleView;
@property (nonatomic, strong) NSString *gameId;

@end

@implementation WPGSubGameRankPage

- (instancetype)initWithGameId:(NSString *)gameId
{
    self = [super init];
    if (self) {
        _gameId = gameId;
    }
    return self;
}

- (void)viewDidLoad {
    self.title = @"达人榜";
    [super viewDidLoad];
    [self initWithView];
    [self dataRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 了解什么时候动画用No，什么时候不用No.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *ruleButtonButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_rule"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(gotoNewPage)];
    self.navigationItem.rightBarButtonItem = ruleButtonButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initWithView
{
    TRACK_SECOND_LEVEL_CLICK(@"ranking", @"ranking_list", nil);
    _rankArray = [NSMutableArray new];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.rankCollectionView];
    [self.view addSubview:self.rankBottomView];
    
    [self.rankCollectionView registerClass:[WPGPlayRankCollectionViewCell class] forCellWithReuseIdentifier:@"WPGPlayRankCollectionViewCell"];
    [self.view addSubview:self.rankCollectionView];
    MJRefreshHeader *header = [IDSRefresh headerWithRefreshingTarget:self
                                                    refreshingAction:@selector(doRefreshData)];
    self.rankCollectionView.mj_header = header;
    
    [self.rankBottomView.layer setShadowColor:NF_Color_C25.CGColor];
    self.rankBottomView.layer.contentsScale = [UIScreen mainScreen].scale;
    self.rankBottomView.layer.shadowOpacity = 0.02f;
    self.rankBottomView.layer.shadowRadius = 4.0f;
    self.rankBottomView.layer.shadowOffset = CGSizeMake(0.0,-4.0);
    self.rankBottomView.layer.masksToBounds = NO;
    [self.view bringSubviewToFront:self.rankBottomView];
}

- (void)dataRequest
{
    @weakify(self);
    [WPGGamePageRequest GameRankRequestGameId:_gameId Success:^(id responseObj) {
        @strongify(self);
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            WPGGamePageRankModel *model = [WPGGamePageRankModel mj_objectWithKeyValues:responseData.data];
            if (model.list) {
                [_rankArray removeAllObjects];
                for (WPGGamePageRanking *rankModel in model.list) {
                    [_rankArray cl_addObject:rankModel];
                }
            }
            if (model.user) {
                _myrankModel = model.user;
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

- (void)addData
{
    [self.rankBottomView bottomViewWithSubGameData:self.myrankModel];
    [self.rankCollectionView reloadData];
}

- (void)doRefreshData
{
    
    [self dataRequest];
    [self.rankCollectionView.mj_header endRefreshing];
}

- (void)gotoNewPage
{
    if (!_ruleView) {
        _ruleView = [[WPGRuleView alloc] init];
        [_ruleView addsubGameFrameView];
        _ruleView.delegate = self;
        [self.view addSubview:_ruleView];
    }
}

- (void)closeTheRuleview:(WPGRuleView *)ruleView
{
    [_ruleView removeFromSuperview];
    _ruleView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return (self.rankArray.count)>8?self.rankArray.count:8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH-26, 65);
}

- (void)openAvatarProfile:(WPGPlayRankCollectionViewCell *)cell WithUid:(NSString *)uid
{
    [self openUserProfile:uid];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGPlayRankCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPGPlayRankCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.lineView.hidden = NO;
    cell.isSubGame = YES;
    NSInteger maxNumber = self.rankArray.count > 8 ? self.rankArray.count:8;
    
    if (indexPath.row == 0) {
        [cell firstCell];
    }
    else if (indexPath.row < maxNumber-1) {
        [cell midCell];
    }
    if (indexPath.row == maxNumber-1) {
        [cell lastCell];
        cell.lineView.hidden = YES;
    }
    if (indexPath.row < _rankArray.count) {
        WPGGamePageRanking *model = [_rankArray cl_objectAtIndex:indexPath.row];
        [cell cellWithData:model RankNum:indexPath.row+1];
    }
    else {
        [cell noDataCell];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

- (UICollectionView *)rankCollectionView
{
    if (!_rankCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(10, 13, 10, 13);
        // cell 上下间距
        layout.minimumInteritemSpacing = 0;
        // cell 间距
        layout.minimumLineSpacing = 0;
        _rankCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-65-64) collectionViewLayout:layout];
        _rankCollectionView.delegate = self;
        _rankCollectionView.dataSource = self;
        _rankCollectionView.backgroundColor = [UIColor clearColor];
        _rankCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _rankCollectionView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-65)];
        _backgroundImageView.image = [UIImage imageNamed:@"bg_chart_purple"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (WPGRankBottomView *)rankBottomView
{
    if (!_rankBottomView) {
        _rankBottomView = [[WPGRankBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-65-65, SCREEN_WIDTH, 65)];
        _rankBottomView.backgroundColor = NF_Color_C1;
        if (IS_IPHONE_X) {
            _rankBottomView.frame = CGRectMake(0, self.view.frame.size.height-65-65-30, SCREEN_WIDTH, 65);
        }
    }
    return _rankBottomView;
}
@end
