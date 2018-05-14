//
//  WPGGameMatchingModel.h
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPGGamePageModel.h"

@class WPGGameMatchingModel,Task,MatchUser,MyWinslevel,MatchList,Winslevel;

@interface WPGGameMatchingModel : NSObject

@property (nonatomic, strong) Task *task;//完成多少次

@property (nonatomic, strong) MatchUser *user;//用户自已的信息

@property (nonatomic, strong) NSArray<MatchList *> *list;//全部排行榜用户信息

@property (nonatomic, strong) WPGGamePageGames *gameInfo; //对应的游戏信息

@end

@interface Task : NSObject

@property (nonatomic, assign) NSInteger currentCompleted;//完成多少次

@property (nonatomic, assign) NSInteger totalCompleted;//共要完成多少次游戏

@property (nonatomic, assign) NSInteger statusGot;//可以领 0 不可领, 1 = 可以领，-1已领完


@end

@interface MatchUser : NSObject

@property (nonatomic, strong) MyWinslevel *winsLevel;

@property (nonatomic, assign) NSInteger ranking;//排名

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *nickname;//昵称

@property (nonatomic, copy) NSString *winsPoint;

@property (nonatomic, copy) NSString *avatar;//头像

@end

@interface MyWinslevel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon;

@end

@interface MatchList : NSObject

@property (nonatomic, strong) Winslevel *winsLevel;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *winsPoint;

@property (nonatomic, copy) NSString *avatar;

@end

@interface Winslevel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon;

@end




