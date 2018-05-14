//
//  WPGCharmRanking.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/13.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGCharmRanking.h"
#import "WPGCharmRankingCollectionViewCell.h"
#import "WPGGamePageRequest.h"
#import "WPGGamePageModel.h"
#import "WPGRankBottomView.h"

@interface WPGCharmRanking () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *rankCollectionView;
@property (nonatomic, strong) NSMutableArray<WPGCharmRankSubModel *> *rankArray;
@property (nonatomic, strong) WPGCharmMyRank *myRankModel;
@property (nonatomic, strong) WPGRankBottomView *rankBottomView;

@end

@implementation WPGCharmRanking

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithView];
    
    if (@available(iOS 11.0, *)) {
        self.rankCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)initWithView
{
    TRACK_SECOND_LEVEL_CLICK(@"ranking", @"ranking_charm_list", nil);
    _rankArray = [NSMutableArray new];
    [self.view addSubview:self.rankCollectionView];
    [self.view addSubview:self.rankBottomView];
    [self.rankCollectionView registerClass:[WPGCharmRankingCollectionViewCell class] forCellWithReuseIdentifier:@"WPGCharmRankingCollectionViewCell"];
    [self.view addSubview:self.rankCollectionView];
    MJRefreshHeader *header = [IDSRefresh headerWithRefreshingTarget:self
                                                    refreshingAction:@selector(doRefreshData)];
    self.rankCollectionView.mj_header = header;
    [self dataRequest];
    
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
    [WPGGamePageRequest CharmRankRequestSuccess:^(id responseObj) {
        @strongify(self);
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            WPGCharmRankModel *model = [WPGCharmRankModel mj_objectWithKeyValues:responseData.data];
            if (model.list) {
                [_rankArray removeAllObjects];
                for (WPGCharmRankSubModel *rankModel in model.list) {
                    [_rankArray cl_addObject:rankModel];
                }
            }

            if (model.user) {
                _myRankModel = model.user;
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
    [self.rankBottomView bottomViewWithCharmData:_myRankModel];
    [self.rankCollectionView reloadData];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.rankArray.count?:0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
    if (indexPath.row == 1 || indexPath.row == 2)
        return CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0);
    if (indexPath.row > 2) {
        if (IS_IPHONE_5) {
            return CGSizeMake(SCREEN_WIDTH/3.0-0.00001, SCREEN_WIDTH/3.0);
        }
        return CGSizeMake(SCREEN_WIDTH/3.0, SCREEN_WIDTH/3.0);
    }
    return CGSizeMake(SCREEN_WIDTH/3.0, SCREEN_WIDTH/3.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGCharmRankingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPGCharmRankingCollectionViewCell" forIndexPath:indexPath];
    
    WPGCharmRankSubModel *model = [_rankArray cl_objectAtIndex:indexPath.row];
    [cell cellWithData:model RankNum:indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGCharmRankSubModel *model = [_rankArray cl_objectAtIndex:indexPath.row];
    NSString *strUid = [NSString stringWithFormat:@"%@", @(model.uid)];
    TRACK_SECOND_LEVEL_CLICK(@"ranking", @"ranking_charm_list_other", strUid);
    [self openUserProfile:strUid];
}

- (UICollectionView *)rankCollectionView
{
    if (!_rankCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
        _rankCollectionView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#F7F6FB"];
        _rankCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _rankCollectionView;
}

- (WPGRankBottomView *)rankBottomView
{
    if (!_rankBottomView) {
        _rankBottomView = [[WPGRankBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-65-65, SCREEN_WIDTH, 65)];
        [_rankBottomView justCharmFrame];
        if (IS_IPHONE_X) {
            _rankBottomView.frame = CGRectMake(0, self.view.frame.size.height-65-65-30, SCREEN_WIDTH, 65);
        }
    }
    return _rankBottomView;
}

@end
