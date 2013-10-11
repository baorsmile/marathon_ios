//
//  PersistenceHelper.m
//  Ryan
//
//  Created by Ryan on 13-10-11.
//  Copyright 2013年 Ryan. All rights reserved.
//

#import "PersistenceHelper.h"

@implementation PersistenceHelper

+ (BOOL)setData:(id)obj forKey:(NSString *)key {
    if (obj && key) {
        NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
        [persistentDefaults setValue:obj forKey:key];
        return [persistentDefaults synchronize];
    }
    return NO;
}

+ (id)dataForKey:(NSString *)key {
    if (key) {
        NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
        return [persistentDefaults objectForKey:key];
    }
    return nil;
}

+ (void)removeForKey:(NSString *)key {
    if (key) {
        NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
        [persistentDefaults removeObjectForKey:key];
    }
}

@end
