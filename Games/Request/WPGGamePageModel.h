//
//  WPGGamePageModel.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/13.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：游戏首页Model列表
//

#import <Foundation/Foundation.h>

@class WPGGamePageRanking,WPGGamePageGames,WPGGamePageMyRank,WPGCharmMyRank,WPGCharmRankSubModel,WPGWinslevel;

/**
 * 游戏首页 Model
 */
@interface WPGGamePageModel : NSObject
// 排行榜数组
@property (nonatomic, strong) NSArray <WPGGamePageRanking *> *ranking;
// 游戏数组
@property (nonatomic, strong) NSArray <WPGGamePageGames *> *games;

@end

/**
 * 排行榜字段 Model
 */
@interface WPGGamePageRanking : NSObject
// 段位
@property (nonatomic, strong) WPGWinslevel *winsLevel;
// 用户uid
@property (nonatomic, assign) NSInteger uid;
// 名称
@property (nonatomic, copy) NSString *nickname;
// 分数
@property (nonatomic, copy) NSString *winsPoint;
// 头像
@property (nonatomic, copy) NSString *avatar;

@end

/**
 * 段位字段 Model
 */
@interface WPGWinslevel : NSObject
// 段位名称
@property (nonatomic, copy) NSString *name;
// 段位图标
@property (nonatomic, copy) NSString *icon;

@end

/**
 * 游戏字段 Model
 */
@interface WPGGamePageGames : NSObject
// 游戏id
@property (nonatomic, copy) NSString *gameId;
// 在线玩游戏人数
@property (nonatomic, copy) NSString *number;
// 游戏小图标（暂没用到）
@property (nonatomic, copy) NSString *icon;
// type=0 单行只有一个cell的显示方式,type=0 单行共有二个cell的显示方式
@property (nonatomic, assign) NSInteger type;
// 游戏封面
@property (nonatomic, copy) NSString *cover;
// 游戏规则html
@property (nonatomic, copy) NSString *content;
// 游戏名字
@property (nonatomic, copy) NSString *name;
// 熟练等级图标（暂没用到）
@property (nonatomic, copy) NSString *levelIcon;
// H5游戏链接
@property (nonatomic, copy) NSString *h5Url;

@end

/**
 * 我的游戏排行榜 Model
 */
@interface WPGGamePageMyRank : NSObject
// 段位标识
@property (nonatomic, strong) WPGWinslevel *winsLevel;
// 我的排名
@property (nonatomic, copy) NSString *ranking;
// 我的uid
@property (nonatomic, assign) NSInteger uid;
// 我的用户名称
@property (nonatomic, copy) NSString *nickname;
// 胜点数
@property (nonatomic, copy) NSString *winsPoint;
// 头像
@property (nonatomic, copy) NSString *avatar;

@end

/**
 * 游戏总排行榜 Model
 */
@interface WPGGamePageRankModel : NSObject
// 游戏总排行榜我的用户数组
@property (nonatomic, strong) WPGGamePageMyRank *user;
// 用户数组
@property (nonatomic, strong) NSArray<WPGGamePageRanking *> *list;

@end

/**
 * 魅力排行榜请求 Model
 */
@interface WPGCharmRankModel : NSObject
// 我的用户魅力排名
@property (nonatomic, strong) WPGCharmMyRank *user;
// 所有用户魅力排名
@property (nonatomic, strong) NSArray<WPGCharmRankSubModel *> *list;

@end

/**
 * 魅力排行榜字段 Model
 */
@interface WPGCharmMyRank : NSObject
// 我的魅力排名
@property (nonatomic, copy) NSString *ranking;
// 用户id
@property (nonatomic, assign) NSInteger uid;
// 用户名称
@property (nonatomic, copy) NSString *nickname;
// 魅力值
@property (nonatomic, copy) NSString *charm;
// 头像
@property (nonatomic, copy) NSString *avatar;

@end

/**
 * 游戏单排行榜字段 Model
 */
@interface WPGCharmRankSubModel : NSObject
// 用户id
@property (nonatomic, assign) NSInteger uid;
// 用户名称
@property (nonatomic, copy) NSString *nickname;
// 魅力值
@property (nonatomic, copy) NSString *charm;
// 头像
@property (nonatomic, copy) NSString *avatar;

@end

/**
 * 活动中心以及没日任务 Model
 */
@interface WPGameTaskModel : NSObject
// 领取状态 0=前往, 1=可领取, 2=已领取
@property (nonatomic, assign) NSInteger taskStatus;
// 任务ID
@property (nonatomic, copy) NSString *taskId;
// 标题
@property (nonatomic, copy) NSString *title;
// 金币
@property (nonatomic, assign) NSInteger money;
// 经验值
@property (nonatomic, assign) NSInteger exp;
// 副标题
@property (nonatomic, copy) NSString *desc;
// 图标
@property (nonatomic, copy) NSString *icon;
// 任务总数
@property (nonatomic, copy) NSString *number;
// 用户完成任务数
@property (nonatomic, copy) NSString *task_completed;

@end

/**
 * 活动中心以及任务中心红点 Model
 */
@interface WPGGetRedNewTaskModel : NSObject
// 每日任务数量
@property (nonatomic, assign) NSInteger dailyCount;
// 每日活动领取数量
@property (nonatomic, assign) NSInteger actvityCount;

@end
