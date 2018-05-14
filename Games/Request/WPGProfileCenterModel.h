//
//  WPGProfileCenterModel.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：用户中心Model
//

#import <Foundation/Foundation.h>

@class WPGUserinfoModel, WPGAchieveMentListModel, WPGameListModel;

/**
 * 个人中心请求 Model
 */
@interface WPGProfileCenterModel : NSObject
// 个人中心model字段
@property (nonatomic, strong) WPGUserinfoModel *userInfo;

@end

/**
 * 个人中心用户信息 Model
 */
@interface WPGUserinfoModel : NSObject
// 下一级最大经验
@property (nonatomic, assign) NSInteger nextLevelExp;
// 出生年月，如：1998-10-01
@property (nonatomic, copy) NSString *birthday;
// 省份
@property (nonatomic, copy) NSString *province;
// 用户资料是否完善：0否，1是
@property (nonatomic, assign) NSInteger isCompleted;
// 胜点数
@property (nonatomic, assign) NSInteger winsPoint;
// （字段咱没用到，但请求里有这个字段）
@property (nonatomic, copy) NSString *openid;
// 段位图标
@property (nonatomic, copy) NSString *winsLevelIcon;
// 昵称
@property (nonatomic, copy) NSString *nickname;
// 段位名称
@property (nonatomic, copy) NSString *levelName;
// 魅力值
@property (nonatomic, assign) NSInteger charm;
// 更新时间
@property (nonatomic, copy) NSString *updateTime;
// 用户中心唯一标示(微信/qq登录默认数字0)
@property (nonatomic, assign) NSInteger ucid;
// 城市
@property (nonatomic, copy) NSString *city;
// 签名
@property (nonatomic, copy) NSString *signature;
// 是否是机器人。0：否，1：是
@property (nonatomic, assign) NSInteger userType;
// 段位名称
@property (nonatomic, copy) NSString *winsLevelName;
// 当前转换后的经验
@property (nonatomic, assign) NSInteger exp;
// 金币数
@property (nonatomic, assign) NSInteger cons;
// 性别: 0、男，1、女
@property (nonatomic, assign) NSInteger gender;
// 用户Uid
@property (nonatomic, assign) NSInteger uid;
// 用户等级
@property (nonatomic, assign) NSInteger level;
// 用户电话
@property (nonatomic, copy) NSString *phone;
// 登录方式：1乐逗用户中心(手机或帐号)，2Wechat，3QQ，4Email
@property (nonatomic, assign) NSInteger platform;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 年龄
@property (nonatomic, assign) NSInteger age;
// 星座，如：狮子座
@property (nonatomic, copy) NSString *constellatory;
// 测试人员标识：0否，1是
@property (nonatomic, assign) NSInteger testers;
// 禁止登录：0否，1是
@property (nonatomic, assign) NSInteger entryInhibited;

@end

/**
 * 个人中心请求 Model
 */
@interface WPGUserAchievementModel : NSObject
// 游戏列表
@property (nonatomic, strong) NSArray<WPGameListModel *> *game;
// 成就列表
@property (nonatomic, strong) NSArray<WPGAchieveMentListModel *> *achv;
// (暂没用到)
@property (nonatomic, copy) NSString *iconUrl;
// 好友关系 0=非好友 1=好友 2=等待通过
@property (nonatomic, copy) NSString *friendStatus;

@end

/**
 * 成就字段 Model
 */
@interface WPGAchieveMentListModel : NSObject
// 解锁状态 0未解锁 1已解锁带new 2已解锁
@property (nonatomic, assign) NSInteger status;
// 成就简介
@property (nonatomic, copy) NSString *intro;
// 奖励名称
@property (nonatomic, copy) NSString *giftName;
// 成就名称
@property (nonatomic, copy) NSString *name;
// 成就图标
@property (nonatomic, copy) NSString *iconUrl;
// 成就大图标
@property (nonatomic, copy) NSString *largeIconUrl;
// 获取时间
@property (nonatomic, copy) NSString *date;
// 成就id
@property (nonatomic, assign) NSInteger achvId;

@end

/**
 * 游戏字段 Model
 */
@interface WPGameListModel : NSObject
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
