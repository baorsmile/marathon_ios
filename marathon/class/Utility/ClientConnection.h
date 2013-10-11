//
//  ClientConnection.h
//  LeheB
//
//  Created by zhangluyi on 11-4-26.
//  Copyright 2011 Lehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionBase.h"

@protocol ClientConnectionDelegate;
@interface ClientConnection : ConnectionBase {
    
}

- (void)requestFinished:(ASIHTTPRequest *)_request;
- (void)requestFailed:(ASIHTTPRequest *)_request;
- (void)request:(ASIHTTPRequest *)_request didReceiveBytes:(long long)bytes;

@end


@protocol ClientConnectionDelegate
//@optional

- (void)stringDataDidFinishLoading:(ASIHTTPRequest *)_request;
- (void)stringDataDidFailLoading:(ASIHTTPRequest *)_request;

@end
