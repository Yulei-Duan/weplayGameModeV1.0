//
//  WPGGameTotalRankPage.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/13.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGGameTotalRankPage.h"
#import "WPGGameRankHeaderView.h"
#import "IDSRefresh.h"
#import "WPGPlayRankCollectionViewCell.h"
#import "WPGRankBottomView.h"
#import "WPGGamePageRequest.h"
#import "WPGGamePageModel.h"

@interface WPGGameTotalRankPage () <UICollectionViewDelegate, UICollectionViewDataSource, WPGPlayRankCollectionViewCellDelegate, WPGGameRankHeaderViewDelegate>

@property (nonatomic, strong) WPGGameRankHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *rankCollectionView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) WPGRankBottomView *rankBottomView;
@property (nonatomic, strong) NSMutableArray *rankArray;
@property (nonatomic, strong) NSArray *subRankArray;
@property (nonatomic, strong) WPGGamePageMyRank *myrankModel;

@end

@implementation WPGGameTotalRankPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    [self dataRequest];
}

- (void)initWithView
{
    TRACK_SECOND_LEVEL_CLICK(@"ranking", @"ranking_list", nil);
    _rankArray = [NSMutableArray new];
    _subRankArray = [NSMutableArray new];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.rankCollectionView];
    [self.view addSubview:self.rankBottomView];
    [self.rankCollectionView addSubview:self.headerView];
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(13, 178, SCREEN_WIDTH-26, 8)];
    whiteView.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPathA = [UIBezierPath bezierPathWithRoundedRect:whiteView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayerA = [[CAShapeLayer alloc] init];
    maskLayerA.frame = whiteView.bounds;
    maskLayerA.path = maskPathA.CGPath;
    whiteView.layer.mask = maskLayerA;
    whiteView.layer.masksToBounds = YES;
    [self.rankCollectionView addSubview:whiteView];
    
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

- (void)doRefreshData
{
    [self dataRequest];
    [self.rankCollectionView.mj_header endRefreshing];
}

- (void)dataRequest
{
    @weakify(self);
    [WPGGamePageRequest GameRankRequestSuccess:^(id responseObj) {
        @strongify(self);
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            WPGGamePageRankModel *model = [WPGGamePageRankModel mj_objectWithKeyValues:responseData.data];
            if (model.list) {
                [_rankArray removeAllObjects];
                _subRankArray = nil;
                for (WPGGamePageRanking *rankModel in model.list) {
                    [_rankArray cl_addObject:rankModel];
                }
            }
            if (_rankArray.count > 3) {
                _subRankArray = [_rankArray subarrayWithRange:NSMakeRange(3,_rankArray.count-3)];
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
    [self.headerView addDataWithArray:self.rankArray];
    [self.rankBottomView bottomViewWithData:self.myrankModel];
    [self.rankCollectionView reloadData];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.rankArray.count-3)>8 ? (self.rankArray.count-3):8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH-26, 65);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGPlayRankCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPGPlayRankCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.lineView.hidden = NO;
    
    NSInteger maxNumber = (self.rankArray.count-3) > 8 ? (self.rankArray.count-3):8;
    
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
    if (indexPath.row < _subRankArray.count) {
        WPGGamePageRanking *model = [_subRankArray cl_objectAtIndex:indexPath.row];
        [cell cellWithData:model RankNum:indexPath.row+4];
    }
    else {
        [cell noDataCell];
    }
    return cell;
}

- (void)openAvatarProfile:(WPGPlayRankCollectionViewCell *)cell WithUid:(NSString *)uid
{
    [self openUserProfile:uid];
    TRACK_SECOND_LEVEL_CLICK(@"ranking", @"ranking_list_others", uid);
}

- (void)openAvatarProfile:(WPGGameRankHeaderView *)headerView withUid:(NSString *)uid
{
    [self openUserProfile:uid];
    TRACK_SECOND_LEVEL_CLICK(@"ranking", @"ranking_list_others", uid);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGGamePageRanking *model = [_subRankArray cl_objectAtIndex:indexPath.row];
    [self openUserProfile:[NSString stringWithFormat:@"%td", model.uid]];
    NSString *str = [NSString stringWithFormat:@"%td", model.uid];
    TRACK_SECOND_LEVEL_CLICK(@"ranking", @"ranking_list_others", str);
}

- (UICollectionView *)rankCollectionView
{
    if (!_rankCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(178, 13, 10, 13);
        // 178
        // cell 上下间距
        layout.minimumInteritemSpacing = 0;
        // cell 间距
        layout.minimumLineSpacing = 0;
        _rankCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-65-64) collectionViewLayout:layout];
        if (IS_IPHONE_X) {
            _rankCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-65-64-30);
        }
        _rankCollectionView.delegate = self;
        _rankCollectionView.dataSource = self;
        _rankCollectionView.backgroundColor = [UIColor clearColor];
        _rankCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _rankCollectionView;
}

- (WPGGameRankHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WPGGameRankHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-65)];
        if (IS_IPHONE_X) {
            _backgroundImageView.frame = CGRectMake(0, -5, SCREEN_WIDTH, self.view.frame.size.height-65-64-30+5);
        }
        _backgroundImageView.image = [UIImage imageNamed:@"bg_chart_purple"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (WPGRankBottomView *)rankBottomView
{
    if (!_rankBottomView) {
        _rankBottomView = [[WPGRankBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-65-65, SCREEN_WIDTH, 65)];
        if (IS_IPHONE_X) {
            _rankBottomView.frame = CGRectMake(0, self.view.frame.size.height-65-65-30, SCREEN_WIDTH, 65);
        }
        _rankBottomView.backgroundColor = NF_Color_C1;
    }
    return _rankBottomView;
}

@end
