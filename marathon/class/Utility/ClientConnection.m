//
//  ClientConnection.m
//  LeheB
//
//  Created by zhangluyi on 11-4-26.
//  Copyright 2011 Lehe. All rights reserved.
//

#import "ClientConnection.h"

@implementation ClientConnection

- (void)requestFinished:(ASIHTTPRequest *)_request {
	
	if (_request.isRequestCancelled) {
		return;
	}
    if ([delegate respondsToSelector:@selector(stringDataDidFinishLoading:)]) {
//        [delegate stringDataDidFinishLoading:_request];
        NSDictionary *jsonDict = [[_request responseString] JSONValue];
        if (jsonDict && [[jsonDict objForKey:@"error_info"] intValue] == 6)//验证失败
        {
            NSDictionary *userInfo = _request.userInfo;
            NSInteger requestID = [[userInfo objForKey:@"requestID"] intValue];
            if (kRequestUserLogout == requestID || kRequestRegister == requestID) {
                //do nothing
            }else {
                [PersistenceHelper removeForKey:@"gToken"];
                [PersistenceHelper removeForKey:@"tencent_accessToken"];
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kEventTokenInvalid object:nil];
                
                DMLog(@"kEventTokenInvalid !!!!!! jsonDict:%@，requestID:%d",jsonDict,requestID);
            }
        }else {
            [delegate stringDataDidFinishLoading:_request];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)_request {
	if (_request.isRequestCancelled) {
		return;
	}
    
    NSDictionary *userInfo = _request.userInfo;
    NSString *requestString = [userInfo objForKey:@"requestString"];
    if (requestString && [requestString length]>0 ) {
        [kRequestResendService addToUnsendRequest:requestString];
    }
    
    if ([delegate respondsToSelector:@selector(stringDataDidFailLoading:)]) {
        [delegate stringDataDidFailLoading:_request];
    }
}

- (void)request:(ASIHTTPRequest *)_request didReceiveBytes:(long long)bytes {
	if (_request.isRequestCancelled) {
		return;
	}
    if ([delegate respondsToSelector:@selector(request:didReceiveBytes:)]) {
        [delegate request:_request didReceiveBytes:(long long)bytes];
    }
}

@end


