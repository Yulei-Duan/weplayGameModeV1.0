//
//  WPGPersonGameView.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGPersonGameView.h"
#import "WPGamePersonCenterGameCollectionViewCell.h"


@implementation WPGPersonGameView

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
    self.layer.masksToBounds = YES;
    _dataArray = [NSMutableArray array];
    [self.gameCollectionView registerClass:[WPGamePersonCenterGameCollectionViewCell class] forCellWithReuseIdentifier:@"WPGamePersonCenterGameCollectionViewCell"];
    [self addSubview:self.gameCollectionView];
}

- (void)loadDataWithModel:(NSArray<WPGameListModel *> *)gameArray;
{
    if (!gameArray || !gameArray.count) {
        return;
    }
    _dataArray = gameArray;
    [self.gameCollectionView reloadData];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count?:0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, 75);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPGamePersonCenterGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPGamePersonCenterGameCollectionViewCell" forIndexPath:indexPath];
    //_dataArray
    WPGameListModel *gameModel = [_dataArray cl_objectAtIndex:indexPath.row];
    [cell loadDataWithModel:gameModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

- (UICollectionView *)gameCollectionView
{
    if (!_gameCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        // cell 垂直是左右间距，水平是上下间距
        layout.minimumInteritemSpacing = 0;
        // cell 垂直是上下间距，水平是左右间距
        layout.minimumLineSpacing = 10;
        
        _gameCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75) collectionViewLayout:layout];
        _gameCollectionView.delegate = self;
        _gameCollectionView.dataSource = self;
        _gameCollectionView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#FBFAFF"];
        _gameCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _gameCollectionView;
}

@end
