//
//  RequestResendService.m
//  Shake
//
//  Created by wangweiqing on 12-07-06.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RequestResendService.h"

@implementation RequestResendService

@synthesize clientConnection,arraySendMessage;

- (id)init {
    self = [super init];
    if (self) {
        
        self.arraySendMessage = [NSMutableArray array];
        NSArray *array = [PersistenceHelper dataForKey:REQUESTARRAY];
        if (array && [array isKindOfClass:[NSArray class]]) {
            [self.arraySendMessage addObjectsFromArray:array];
            
            while ([arraySendMessage count] > MAX_REQUEST_COUNT) {
                [arraySendMessage removeLastObject];
            }
        }
        
        if (self.clientConnection == nil) {
            self.clientConnection = [[ClientConnection alloc] init];
            self.clientConnection.delegate = self;
        }
        
        isRequestSending = NO;
        [self performSelector:@selector(sendTopOneRequest) withObject:nil afterDelay:60];
    }
    return self;
}

- (void)stringDataDidFinishLoading:(ASIHTTPRequest *)_request {
    
    [clientConnection cancel];
    
    NSDictionary *userInfo = _request.userInfo;
    NSInteger requestID = [[userInfo objForKey:@"requestID"] intValue];
    
    if (requestID == kRequestResendRequest) {
        NSDictionary *jsonDict = [[_request responseString] JSONValue];
        if (jsonDict == nil) {
            //请求通知服务器失败
            isRequestSending = NO;
            [self sendTopOneRequest];
        } else if ([[jsonDict objForKey:@"result"] intValue] == 0) {
            if (arraySendMessage && [arraySendMessage count]>0) {
                [arraySendMessage removeObjectAtIndex:0];
                isRequestSending = NO;
                [self sendTopOneRequest];
            }
        }else {
            DMLog(@"resend request succeed:%@",[userInfo objForKey:@"requestString"]);
            //通知成功，从等待发送队列中删除
            NSString *message = [userInfo objForKey:@"requestString"];
            [self removeFromUnsendRequest:message];
            isRequestSending = NO;
            [self sendTopOneRequest];
        }
    }
}

- (void)stringDataDidFailLoading:(ASIHTTPRequest *)_request {
	[clientConnection cancel];
    
    NSDictionary *userInfo = _request.userInfo;
    NSInteger requestID = [[userInfo objForKey:@"requestID"] intValue];
    
    if (requestID == kRequestResendRequest) {
        //请求通知服务器失败
        isRequestSending = NO;
        [self sendTopOneRequest];
        return;
    }
}

- (void)sendTopOneRequest {
    @synchronized(REQUESTARRAY) 
    {    
        if (!isRequestSending && [self hasUnsendedRequest]) {
            if (self.clientConnection == nil) {
                self.clientConnection = [[ClientConnection alloc] init];
                self.clientConnection.delegate = self;
            }
            
            if (arraySendMessage && [arraySendMessage count]>0) {
                NSString *requestString = [arraySendMessage objectAtIndex:0];
                if (requestString && [requestString length] > 0) {
                    isRequestSending = YES;
                    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                    [infoDict setValue:requestString  forKey:@"requestString"];
                    [infoDict setValue:[NSNumber numberWithInt:kRequestResendRequest] forKey:@"requestID"];
                    [clientConnection get:requestString withInfo:infoDict];
                }else {
                    [arraySendMessage removeObjectAtIndex:0];
                    [self sendTopOneRequest];
                }
            }
        }   
    }
}

- (void)sendAllRequest {
    @synchronized(REQUESTARRAY) 
    {    
        if ([self hasUnsendedRequest]) {
            if (self.clientConnection == nil) {
                self.clientConnection = [[ClientConnection alloc] init];
                self.clientConnection.delegate = self;
            }
            
            for (NSString *requestString in self.arraySendMessage) {
                if (requestString && [requestString length] > 0) {
                    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                    [infoDict setValue:requestString  forKey:@"requestString"];
                    [infoDict setValue:[NSNumber numberWithInt:kRequestResendRequest] forKey:@"requestID"];
                    [clientConnection get:requestString withInfo:infoDict];
                }
            }
        }   
    }
}

- (BOOL)hasUnsendedRequest {
    if (self.arraySendMessage && [self.arraySendMessage count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)addToUnsendRequest:(NSString *)request {
    @synchronized(REQUESTARRAY) {
        if (request == nil) {
            return;
        }
        
        if (arraySendMessage && [arraySendMessage count]>0) {
            if ([arraySendMessage count]>MAX_REQUEST_COUNT) {
                return;
            }
            
            //if exisit
            BOOL isExisit = NO;
            for (int i = 0; i < [self.arraySendMessage count]; i++) {
                NSString *exisitRequest = [self.arraySendMessage objectAtIndex:i];
                if (exisitRequest && [exisitRequest length] > 0 && [exisitRequest isEqualToString:request]) {
                    isExisit = YES;
                    break;
                }
            }
            if (!isExisit) {
                [arraySendMessage insertObject:request atIndex:0];
            }
        }else {
            [self.arraySendMessage addObject:request];
        }
        
        [self sendTopOneRequest];
    }
}

- (void)removeFromUnsendRequest:(NSString *)message {
    @synchronized(REQUESTARRAY) {
        if (message && [message length] > 0) {
            NSMutableArray *delArray = [NSMutableArray array];
            for (int i = 0; i < [self.arraySendMessage count]; i++) {
                NSString *unsendMessage = [self.arraySendMessage objectAtIndex:i];
                if (unsendMessage && [unsendMessage length] > 0 && [unsendMessage isEqualToString:message]) {
                    [delArray addObject:unsendMessage];
                }
            }
            
            [self.arraySendMessage removeObjectsInArray:delArray];
        }
    }    
}

- (void)removeAllRequest {
    @synchronized(REQUESTARRAY) {
        [self.arraySendMessage removeAllObjects];
    }
}

@end
