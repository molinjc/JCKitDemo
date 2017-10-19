//
//  UIColor+JCSeries.h
//  JCKit
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define _RGB16(value) _RGBA16(value, 1.0)
#define _RGBA16(value, a) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:a]

/** 颜色系列 */
@interface UIColor (JCSeries)

#pragma mark - **************** 红色系

/** 薄雾玫瑰*/
@property(class, nonatomic, readonly) UIColor *mistyRose;
/** 浅鲑鱼色*/
@property(class, nonatomic, readonly) UIColor *lightSalmon;
/** 淡珊瑚色*/
@property(class, nonatomic, readonly) UIColor *lightCoral;
/** 鲑鱼色*/
@property(class, nonatomic, readonly) UIColor *salmonColor;
/** 珊瑚色*/
@property(class, nonatomic, readonly) UIColor *coralColor;
/** 番茄*/
@property(class, nonatomic, readonly) UIColor *tomatoColor;
/** 橙红色*/
@property(class, nonatomic, readonly) UIColor *orangeRed;
/** 印度红*/
@property(class, nonatomic, readonly) UIColor *indianRed;
/** 猩红*/
@property(class, nonatomic, readonly) UIColor *crimsonColor;
/** 耐火砖*/
@property(class, nonatomic, readonly) UIColor *fireBrick;

#pragma mark - **************** 黄色系

/** 玉米色*/
@property(class, nonatomic, readonly) UIColor *cornColor;
/** 柠檬薄纱*/
@property(class, nonatomic, readonly) UIColor *LemonChiffon;
/** 苍金麒麟*/
@property(class, nonatomic, readonly) UIColor *paleGodenrod;
/** 卡其色*/
@property(class, nonatomic, readonly) UIColor *khakiColor;
/** 金色*/
@property(class, nonatomic, readonly) UIColor *goldColor;
/** 雌黄*/
@property(class, nonatomic, readonly) UIColor *orpimentColor;
/** 藤黄*/
@property(class, nonatomic, readonly) UIColor *gambogeColor;
/** 雄黄*/
@property(class, nonatomic, readonly) UIColor *realgarColor;
/** 金麒麟色*/
@property(class, nonatomic, readonly) UIColor *goldenrod;
/** 乌金*/
@property(class, nonatomic, readonly) UIColor *darkGold;

#pragma mark - **************** 绿色系
/** 苍绿*/
@property(class, nonatomic, readonly) UIColor *paleGreen;
/** 淡绿色*/
@property(class, nonatomic, readonly) UIColor *lightGreen;
/** 春绿*/
@property(class, nonatomic, readonly) UIColor *springGreen;
/** 绿黄色*/
@property(class, nonatomic, readonly) UIColor *greenYellow;
/** 草坪绿*/
@property(class, nonatomic, readonly) UIColor *lawnGreen;
/** 酸橙绿*/
@property(class, nonatomic, readonly) UIColor *limeColor;
/** 森林绿*/
@property(class, nonatomic, readonly) UIColor *forestGreen;
/** 海洋绿*/
@property(class, nonatomic, readonly) UIColor *seaGreen;
/** 深绿*/
@property(class, nonatomic, readonly) UIColor *darkGreen;
/** 橄榄(墨绿)*/
@property(class, nonatomic, readonly) UIColor *olive;

#pragma mark - **************** 青色系

/** 淡青色*/
@property(class, nonatomic, readonly) UIColor *lightCyan;
/** 苍白绿松石*/
@property(class, nonatomic, readonly) UIColor *paleTurquoise;
/** 绿碧*/
@property(class, nonatomic, readonly) UIColor *aquamarine;
/** 绿松石*/
@property(class, nonatomic, readonly) UIColor *turquoise;
/** 适中绿松石*/
@property(class, nonatomic, readonly) UIColor *mediumTurquoise;
/** 美团色*/
@property(class, nonatomic, readonly) UIColor *meituanColor;
/** 浅海洋绿*/
@property(class, nonatomic, readonly) UIColor *lightSeaGreen;
/** 深青色*/
@property(class, nonatomic, readonly) UIColor *darkCyan;
/** 水鸭色*/
@property(class, nonatomic, readonly) UIColor *tealColor;
/** 深石板灰*/
@property(class, nonatomic, readonly) UIColor *darkSlateGray;

#pragma mark - **************** 蓝色系

/** 天蓝色*/
@property(class, nonatomic, readonly) UIColor *skyBlue;
/** 淡蓝*/
@property(class, nonatomic, readonly) UIColor *lightBLue;
/** 深天蓝*/
@property(class, nonatomic, readonly) UIColor *deepSkyBlue;
/** 道奇蓝*/
@property(class, nonatomic, readonly) UIColor *doderBlue;
/** 矢车菊*/
@property(class, nonatomic, readonly) UIColor *cornflowerBlue;
/** 皇家蓝*/
@property(class, nonatomic, readonly) UIColor *royalBlue;
/** 适中的蓝色*/
@property(class, nonatomic, readonly) UIColor *mediumBlue;
/** 深蓝*/
@property(class, nonatomic, readonly) UIColor *darkBlue;
/** 海军蓝*/
@property(class, nonatomic, readonly) UIColor *navyColor;
/** 午夜蓝*/
@property(class, nonatomic, readonly) UIColor *midnightBlue;

#pragma mark - **************** 紫色系

/** 薰衣草*/
@property(class, nonatomic, readonly) UIColor *lavender;
/** 蓟*/
@property(class, nonatomic, readonly) UIColor *thistleColor;
/** 李子*/
@property(class, nonatomic, readonly) UIColor *plumColor;
/** 紫罗兰*/
@property(class, nonatomic, readonly) UIColor *violetColor;
/** 适中的兰花紫*/
@property(class, nonatomic, readonly) UIColor *mediumOrchid;
/** 深兰花紫*/
@property(class, nonatomic, readonly) UIColor *darkOrchid;
/** 深紫罗兰色*/
@property(class, nonatomic, readonly) UIColor *darkVoilet;
/** 泛蓝紫罗兰*/
@property(class, nonatomic, readonly) UIColor *blueViolet;
/** 深洋红色*/
@property(class, nonatomic, readonly) UIColor *darkMagenta;
/** 靛青*/
@property(class, nonatomic, readonly) UIColor *indigoColor;

#pragma mark - **************** 灰色系

/** 白烟*/
@property(class, nonatomic, readonly) UIColor *whiteSmoke;
/** 鸭蛋*/
@property(class, nonatomic, readonly) UIColor *duckEgg;
/** 亮灰*/
@property(class, nonatomic, readonly) UIColor *gainsboroColor;
/** 蟹壳青*/
@property(class, nonatomic, readonly) UIColor *carapaceColor;
/** 银白色*/
@property(class, nonatomic, readonly) UIColor *silverColor;
/** 暗淡的灰色*/
@property(class, nonatomic, readonly) UIColor *dimGray;

#pragma mark - **************** 白色系

/** 海贝壳*/
@property(class, nonatomic, readonly) UIColor *seaShell;
/** 雪*/
@property(class, nonatomic, readonly) UIColor *snowColor;
/** 亚麻色*/
@property(class, nonatomic, readonly) UIColor *linenColor;
/** 花之白*/
@property(class, nonatomic, readonly) UIColor *floralWhite;
/** 老饰带*/
@property(class, nonatomic, readonly) UIColor *oldLace;
/** 象牙白*/
@property(class, nonatomic, readonly) UIColor *ivoryColor;
/** 蜂蜜露*/
@property(class, nonatomic, readonly) UIColor *honeydew;
/** 薄荷奶油*/
@property(class, nonatomic, readonly) UIColor *mintCream;
/** 蔚蓝色*/
@property(class, nonatomic, readonly) UIColor *azureColor;
/** 爱丽丝蓝*/
@property(class, nonatomic, readonly) UIColor *aliceBlue;
/** 幽灵白*/
@property(class, nonatomic, readonly) UIColor *ghostWhite;
/** 淡紫红*/
@property(class, nonatomic, readonly) UIColor *lavenderBlush;
/** 米色*/
@property(class, nonatomic, readonly) UIColor *beigeColor;

#pragma mark - **************** 棕色系

/** 黄褐色*/
@property(class, nonatomic, readonly) UIColor *tanColor;
/** 玫瑰棕色*/
@property(class, nonatomic, readonly) UIColor *rosyBrown;
/** 秘鲁*/
@property(class, nonatomic, readonly) UIColor *peruColor;
/** 巧克力*/
@property(class, nonatomic, readonly) UIColor *chocolateColor;
/** 古铜色*/
@property(class, nonatomic, readonly) UIColor *bronzeColor;
/** 黄土赭色*/
@property(class, nonatomic, readonly) UIColor *siennaColor;
/** 马鞍棕色*/
@property(class, nonatomic, readonly) UIColor *saddleBrown;
/** 土棕*/
@property(class, nonatomic, readonly) UIColor *soilColor;
/** 栗色*/
@property(class, nonatomic, readonly) UIColor *maroonColor;
/** 乌贼墨棕*/
@property(class, nonatomic, readonly) UIColor *inkfishBrown;

#pragma mark - **************** 粉色系

/** 水粉*/
@property(class, nonatomic, readonly) UIColor *waterPink;
/** 藕色*/
@property(class, nonatomic, readonly) UIColor *lotusRoot;
/** 浅粉红*/
@property(class, nonatomic, readonly) UIColor *lightPink;
/** 适中的粉红*/
@property(class, nonatomic, readonly) UIColor *mediumPink;
/** 桃红*/
@property(class, nonatomic, readonly) UIColor *peachRed;
/** 苍白的紫罗兰红色*/
@property(class, nonatomic, readonly) UIColor *paleVioletRed;
/** 深粉色*/
@property(class, nonatomic, readonly) UIColor *deepPink;

@end
