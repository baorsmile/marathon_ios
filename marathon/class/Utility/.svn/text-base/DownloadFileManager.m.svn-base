//
//  DownloadFileManager.m
//  LeheV2
//
//  Created by  apple on 11-7-5.
//  Copyright 2011 www.lehe.com. All rights reserved.
//

#import "DownloadFileManager.h"

@implementation DownloadFileManager

+ (NSMutableArray *)initDownLoadFileManager {
	
	NSError* error = nil;
	NSMutableArray *downFilesArray;
	BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DOWNLOAD_FOLDER];
	
	if (directoryExists != YES)
		[[NSFileManager defaultManager] createDirectoryAtPath:DOWNLOAD_FOLDER withIntermediateDirectories:YES attributes:nil error:&error];
	
	if(error == nil)
	{
		downFilesArray = [DownloadFileManager filesByModDate:DOWNLOAD_FOLDER];

		NSInteger filesCount = [downFilesArray count];
		
		if ((filesCount) >= MOST_FILE_CAPACITY) {
			for (int i = 0; i<FILE_CLEAN_THRESHOLD; i++) {
				NSMutableString* fullpath = [[NSMutableString alloc] initWithFormat:@"%@/",DOWNLOAD_FOLDER];
				NSString* name = [downFilesArray objectAtIndex:0];
				[fullpath appendString:name];
				[[NSFileManager defaultManager] removeItemAtPath:fullpath error:&error];
				if (error == nil)
					[downFilesArray removeObjectAtIndex:0];
				[fullpath release];
			}
		}
		return downFilesArray;
	}
	else {
		// DMLog(@"create download directory failed!!!");
		return nil;
	}

}

+(NSMutableArray *)filesByModDate: (NSString *)fullPath
{
    NSError* error = nil;	
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:&error];
    if(error == nil)
    {
        NSMutableDictionary* filesAndProperties = [NSMutableDictionary	dictionaryWithCapacity:[files count]];
        for(NSString* path in files)
        {
            NSDictionary* properties = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:[fullPath stringByAppendingPathComponent:path]
                                        error:&error];
            NSDate* modDate = [properties objectForKey:NSFileModificationDate];
			
            if(error == nil)
            {
                [filesAndProperties setValue:modDate forKey:path];
            }
        }
		
        NSArray* tempArray = [filesAndProperties keysSortedByValueUsingSelector:@selector(compare:)];		
		NSMutableArray* resultArray =[[tempArray mutableCopy] autorelease];
		
		return resultArray;
		
    }
	
	return [NSMutableArray arrayWithObjects:nil];
}

+(void)managerDownFile:(NSString*)filename {

	if (kAppDelegate.gDownLoadFiles)
	{
		NSInteger filesCount = [kAppDelegate.gDownLoadFiles count];
		NSError* error = nil;
		
		if ((filesCount+1) >= MOST_FILE_CAPACITY) {
			for (int i = 0; i<FILE_CLEAN_THRESHOLD; i++) {
				NSMutableString* fullpath = [[NSMutableString alloc] initWithFormat:@"/%@",DOWNLOAD_FOLDER];
				NSString* name = [kAppDelegate.gDownLoadFiles objectAtIndex:0];
				[fullpath appendString:name];
				[[NSFileManager defaultManager] removeItemAtPath:fullpath error:&error];
				if (error == nil)
					[kAppDelegate.gDownLoadFiles removeObjectAtIndex:0];
				[fullpath release];
			}
		}
		
		[kAppDelegate.gDownLoadFiles addObject:filename];
	}
}

@end
