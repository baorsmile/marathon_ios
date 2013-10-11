//
//  Utility.h
//  LeheB
//
//  Created by zhangluyi on 11-5-4.
//  Copyright 2011年 Lehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Utility : NSObject {
    
}

+ (void)addShadowByLayer:(UIView *)view;
+ (void)addShadow:(UIView *)view;
+ (void)addButtomShadow:(UIView *)view withOffset:(CGFloat)shadowOffset;
+ (void)addBorderColor:(UIView *)imageView;
+ (void)clearBorderColor:(UIView *)imageView;
+ (void)addRoundCornerToView:(UIView *)view withRadius:(CGFloat)radius;
+ (NSString *)codeOfString:(NSString*)string;
+ (BOOL)isNumberString:(NSString*)str;

+ (void)doAnimationFromLeft:(BOOL)leftDir
                   delegate:(id)_delegate 
                       view:(UIView *)_view 
                   duration:(CGFloat)duration;

+ (BOOL)isCharacterChinese:(unichar)ch;
char indexTitleOfString(unsigned short string);
+ (BOOL)isCharacter:(unichar)ch;
+ (CGFloat)getFloatRandom;
+ (NSInteger)getIntegerRandomWithInMax:(NSInteger)max;

+ (UIAlertView *)startWebViewMaskWithMessage:(NSString *)_message;

+ (void)disMissMaskView:(UIAlertView **)_alertView;

+ (NSMutableString *)URLStringMakeWithDict:(NSDictionary *)dict;

+ (void)setWebView:(UIWebView *)webView withId:(NSInteger)webId;

+ (void)changeNavigation:(UINavigationItem *)navItem Title:(NSString *)title;

+ (NSString *)descriptionForDateInterval:(NSString *)dateString;
+ (NSString *)desForDateInterval2:(NSString *)dateString;
+ (void)chageStandardFile:(NSString *)srcPath toAppleFile:(NSString *)desPath;

+ (NSString*)getRecordFilename:(NSString*)urlString;
+ (BOOL)isValidLatLon:(double)lat Lon:(double)lon;
+ (NSString*)getPhotoDownloadURL:(NSString*)currentURLString sizeType:(NSString*)sizetype;

+ (NSMutableDictionary *)datasourceFromListArray:(NSArray *)array;

+ (void)addBorderColor:(UIView *)view withColor:(UIColor *)color width:(CGFloat)width;
+ (NSString *)descriptionForDistance:(NSInteger)distance;

+ (double)distanceFromPoint:(GPoint)point1 toPoint:(GPoint)point2;

+ (NSString *)item:(NSString *)name descriptionWithCount:(NSInteger)count;

+ (NSString *)date:(NSDate *)date descriptorWithFormate:(NSString *)dateFormat;

+ (NSDictionary *)parseByDate:(NSDate *)date;
+ (NSDictionary *)intervalForDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSString *)setTimeInt:(NSTimeInterval)timeSeconds setTimeFormat:(NSString *)timeFormatStr setTimeZome:(NSString *)timeZoneStr;

+ (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)formatString;
+ (NSString*)dayDescriptionFromNow:(NSDate*)theDate;
+ (NSString*)weekdayForDate:(NSDate*)theDate;

+ (BOOL)isSameDayBetween:(NSDate*)aDate with:(NSDate*)bDate;

+ (BOOL)saveImageToSandbox:(UIImage*)image imageName:(NSString*)imageName ;
+ (UIImage*)getImageFromSandbox:(NSString*)imageName;
+ (void)deleteImageFromSandbox:(NSString*)imageName;
+ (NSString *)desForDateInterval:(NSString *)dateString;

+ (NSString*)base64encode:(NSString*)str;
+ (NSData *)Base64DecodeString:(NSString *)string;

+ (BOOL)validateEmail:(NSString*)email;

+ (UIImage *)saveScreen:(UIView*)subView;

//按时间分组数据
+ (NSMutableArray*)groupByDate:(NSArray*)jsonBlocks timeKey:(NSString*)timeKey;
+ (BOOL)saveUserCollectedImageToSandbox:(UIImage*)image imageName:(NSString*)imageName;
+ (UIImage*)getUserCollectedImageFromSandbox:(NSString*)imageName;
+ (void)deleteUserCollectedImageFromSandbox:(NSString *)imageName;

+ (NSString*)iconFilenameByFirstIndex:(NSInteger)firstIndex SecondIndex:(NSInteger)secondIndex;

//设置cookie
+ (void)setCookie:(NSDictionary*)cookieProperties;
//清除cookie
+ (void)deleteCookieForURL:(NSString*)urlstr;
// 保存Archiver数据到本地
+ (BOOL)SetLocalData:(NSString *)dataFile dataObject:(NSMutableDictionary *)dataObject;
// 读取本地保存的Archiver数据
+ (NSMutableDictionary *)GetLocalData:(NSString *)dataFile;

//解析URL，组装成key:value形式
+ (NSMutableDictionary*)urlParser:(NSString*)urlString appScheme:(NSString*)appScheme;

+ (NSData *)URLDecodeString:(NSString *)string;
+ (NSString *)urlEncode:(const void *)bytes length:(NSUInteger)length ;


//等比压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)largeImage scaledToSize:(CGSize)smallSize;
//从url中截取图片SN
+ (NSString*)getImageSNFromUrl:(NSString*)urlString;

//html 颜色值转换 UIColor，比如：#FF9900、0XFF9900 等颜色字符串，转换为 UIColor 对象
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

//api 请求签名算法
+ (NSString*)generateRequestSign:(NSString*)requestString partnerKey:(NSString*)partnerKey;

//替换表情字符为系统显示格式
+ (NSString *)replaceUnicodeToiOSText:(NSString *)unicodeStr;


//判断某个点是否在某个区域里
+ (BOOL)isPointInRect:(CGPoint)p rect:(CGRect)rect;

//得到过滤后的后台进程名
+ (NSMutableArray *)getBackRunningExe;
//从本地存储的后台进程名数据中删除一条数据
+ (void)deleteProcessFromStoredData:(NSDictionary*)toDeleteGameInfo;

//重新保存已安装应用
+ (NSMutableArray*)restoreInstalledApps:(NSArray *)tosaveArray;
//添加已安装应用
+ (void)saveInstalledApps:(NSArray *)unsavedArray;
+ (void)saveInstalledApp:(NSDictionary *)toSaveGameDict;
+ (NSArray *)getInstalledApps;
+ (BOOL)deleteInstalledApps:(NSDictionary *)dic;

//是否已经添加过某游戏
+ (BOOL)isAttentionThisGame:(NSDictionary*)gameDict;
//保存应用信息到用户手动添加数据中，同时，它还调用saveInstalledApp
+ (void)saveUserAddApp:(NSDictionary *)toSaveGameDict;

//未读消息数量获取与设置
//获得某一级或二级未读消息数量
+ (NSInteger)getUnreadMsgNumByMainKey:(NSString*)mainKey subKey:(NSString*)subKey;
//设置某一级或二级未读消息数量
+ (void)setUnreadMsgNumByMainKey:(NSString*)mainKey subKey:(NSString*)subKey countValue:(NSInteger)countValue postNotification:(BOOL)needPostNotification;
//增加某二级未读消息数量
+ (NSInteger)increaseUnreadMsgNumByMainKey:(NSString*)mainKey subKey:(NSString*)subKey increaseValue:(NSInteger)increase postNotification:(BOOL)needPostNotification;
//减少某二级未读消息数量
+ (NSInteger)decreaseUnreadMsgNumByMainKey:(NSString*)mainKey subKey:(NSString*)subKey decreaseValue:(NSInteger)decrease postNotification:(BOOL)needPostNotification;
//清除已经不存在的游戏相关的未读消息
+ (void)cleanDisappearedGameUnreadMsgCount:(BOOL)needPostNotification;
//清除已经不存在的好友相关的未读消息
+ (void)cleanDisappearedFriendUnreadMsgCount:(NSArray*)allFriendsArray postNotification:(BOOL)needPostNotification;

//截取部分图像
+ (UIImage*)getSubImage:(UIImage*)originalImage forRect:(CGRect)rect;
@end
