//
//  URLParser.h
//  LeheB
//
//  Created by zhangluyi on 11-5-12.
//  Copyright 2011年 Lehe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end
