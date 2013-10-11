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


//截取部分图像
+ (UIImage*)getSubImage:(UIImage*)originalImage forRect:(CGRect)rect;
@end
