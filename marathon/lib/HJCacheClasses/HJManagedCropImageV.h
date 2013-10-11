//
//  HJManagedCropImageV.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

//强制压缩方式：1、宽度；2、高度；3、自动
typedef enum _ScaledForceType {
    ScaledForceWidth = 1,
    ScaledForceHeight = 2,
    ScaledForceAuto = 3
}ScaledForceType;

@class HJManagedImageV;

@interface HJManagedCropImageV : HJManagedImageV {
    
   ScaledForceType imageScaledForceType;
}

@property (nonatomic, assign) ScaledForceType imageScaledForceType;//强制按 宽度／高度 压缩

@property (nonatomic, assign) BOOL isCropForceCenter;//是否强制从图片中间部分进行截取，yes将忽略cropRect的x&&y

@property (nonatomic, retain) UIImage* cropImage;
@property (nonatomic, assign) CGSize scaledSize;
@property (nonatomic, assign) CGRect cropRect;


@end





