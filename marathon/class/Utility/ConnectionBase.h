//
//  ConnectionBase.h
//  LeheB
//
//  Created by zhangluyi on 11-4-21.
//  Copyright 2011 Lehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "ASIProgressDelegate.h"

@interface ConnectionBase : NSObject<ASIProgressDelegate, ASIHTTPRequestDelegate> {
    id delegate;
    NSInteger statusCode;
    BOOL needAuth;
    //Queue
    NSOperationQueue *queue;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) id delegate;
@property (nonatomic, unsafe_unretained) int statusCode;

- (id)init;
- (void)setDefaultTimeOutSeconds:(NSTimeInterval)newTimeOutSeconds;
- (ASIHTTPRequest *)get:(NSString *)URL; //同步调用
- (void)get:(NSString *)URL withID:(NSInteger)_id needResend:(BOOL)isNeedResend;
- (void)get:(NSString*)URL withID:(NSInteger)_id;
- (void)get:(NSString *)URL withName:(NSString*)_name;
- (void)get:(NSString *)URL withInfo:(NSDictionary *)info;

- (void)post:(NSString *)URL withString:(NSString *)jsonString;

- (void)postToURL:(NSString *)URL withData:(NSDictionary *)uploadDataDict requestID:(NSInteger)_id type:(NSInteger)type needResend:(BOOL)isNeedResend;
- (void)postToURL:(NSString *)URL withData:(NSDictionary *)uploadDataDict requestID:(NSInteger)_id type:(NSInteger)type;

- (void)postToURL:(NSString *)URL withData:(NSDictionary *)uploadDataDict requestName:(NSString*)_name requestType:(NSInteger)_requestType type:(NSInteger)type needResend:(BOOL)isNeedResend;
- (void)postToURL:(NSString *)URL withData:(NSDictionary *)uploadDataDict requestName:(NSString*)_name requestType:(NSInteger)_requestType type:(NSInteger)type ;

- (void)cancel;
- (void)disableAllRequest;
- (ASIHTTPRequest *)get:(NSString *)URL withTimeoutSecond:(NSTimeInterval)second;
@end
