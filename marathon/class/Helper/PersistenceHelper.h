//
//  PersistenceHelper.m
//  Ryan
//
//  Created by Ryan on 13-10-11.
//  Copyright 2013年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersistenceHelper : NSObject {
    
}

+ (BOOL)setData:(id)obj forKey:(NSString *)key;
+ (id)dataForKey:(NSString *)key;
+ (void)removeForKey:(NSString *)key;

@end
