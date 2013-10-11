//
//  DownloadFileManager.h
//  LeheV2
//
//  Created by  apple on 11-7-5.
//  Copyright 2011 www.lehe.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadFileManager : NSObject {

}

+ (NSMutableArray *)filesByModDate: (NSString *)fullPath;
+ (NSMutableArray *)initDownLoadFileManager;
+(void)managerDownFile:(NSString*)filename;

@end
