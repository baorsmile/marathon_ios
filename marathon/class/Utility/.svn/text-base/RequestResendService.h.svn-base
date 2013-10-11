//
//  RequestResendService.h
//  Shake
//
//  Created by wangweiqing on 12-07-06.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_REQUEST_COUNT     200

#define REQUESTARRAY                @"REQUESTARRAY"

@interface RequestResendService : NSObject {

    ClientConnection *clientConnection;

    NSMutableArray *arraySendMessage; //保存所有未发送成功的请求
    
    BOOL isRequestSending;
}

@property (nonatomic, strong) ClientConnection *clientConnection;
@property (nonatomic, strong) NSMutableArray *arraySendMessage;

- (BOOL)hasUnsendedRequest;
- (void)addToUnsendRequest:(NSString *)request;
- (void)removeFromUnsendRequest:(NSString *)message;
- (void)sendAllRequest;
- (void)removeAllRequest;

@end
