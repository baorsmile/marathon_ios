//
//  ConnectionBase.m
//  LeheB
//
//  Created by zhangluyi on 11-4-21.
//  Copyright 2011 Lehe. All rights reserved.
//

#import "ConnectionBase.h"

@implementation ConnectionBase
@synthesize statusCode, delegate, queue;

- (id)init {
    self = [super init];
    if (self) {
		self.delegate = nil;
        statusCode = 0;
        needAuth = false;
        [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
        [ASIHTTPRequest setDefaultTimeOutSeconds:30];
    }
    
    return self;
}

- (void)setDefaultTimeOutSeconds:(NSTimeInterval)newTimeOutSeconds
{
	[ASIHTTPRequest setDefaultTimeOutSeconds:newTimeOutSeconds];
}

- (void)disableAllRequest {
    
    self.delegate = nil;
    
    for (ASIHTTPRequest *activeRequest in [self.queue operations]) {
        activeRequest.isRequestCancelled = YES;
        activeRequest.delegate = nil;
    }
    
    if (queue && [[queue operations] count] > 0) 
	{
        for (ASIHTTPRequest *request in [self.queue operations]) {
            [request clearDelegatesAndCancel];
        }
    }
}

- (void)get:(NSString *)URL withInfo:(NSDictionary *)info {
    if (self.queue == nil) {
        self.queue = [[NSOperationQueue alloc] init];
        [self.queue setMaxConcurrentOperationCount:2];
    }
    NSString *_URL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)URL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:_URL];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = info;
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    [self.queue addOperation:request];
}

- (void)get:(NSString *)URL withID:(NSInteger)_id needResend:(BOOL)isNeedResend {
    if (isNeedResend) {
        //失败重发
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
        [infoDict setValue:URL forKey:@"requestString"];
        [infoDict setValue:[NSNumber numberWithInt:1] forKey:@"needResend"];
        [infoDict setValue:[NSNumber numberWithInt:_id] forKey:@"requestID"];
        [self get:URL withInfo:infoDict];
    }else {
        [self get:URL withID:_id];
    }
}

- (void)get:(NSString *)URL withID:(NSInteger)_id {    
    if (URL) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_id] forKey:@"requestID"];
        [self get:URL withInfo:userInfo];
    }
}

- (void)get:(NSString *)URL withName:(NSString*)_name {    
    if (URL) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:_name forKey:@"requestName"];
        [self get:URL withInfo:userInfo];
    }
}

- (ASIHTTPRequest *)get:(NSString *)URL {
    NSString *_URL = [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)URL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8) autorelease];
    NSURL *url = [NSURL URLWithString:_URL];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    return request;
}

- (ASIHTTPRequest *)get:(NSString *)URL withTimeoutSecond:(NSTimeInterval)second {
    NSString *_URL = [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)URL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8) autorelease];
    NSURL *url = [NSURL URLWithString:_URL];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:second];
    [request startSynchronous];
    return request;
}


// need to override in subclass
- (void)requestFinished:(ASIHTTPRequest *)_request {
    
}

- (void)requestFailed:(ASIHTTPRequest *)_request {
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {

}

- (void)post:(NSString *)URL withString:(NSString *)jsonString {
    NSURL *url = [NSURL URLWithString:URL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]]; 
    [request startAsynchronous];
    
}

- (void)postToURL:(NSString *)URL withData:(NSDictionary *)uploadDataDict requestID:(NSInteger)_id type:(NSInteger)type needResend:(BOOL)isNeedResend {
    
    NSString *_URL = [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)URL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8) autorelease];
    NSURL *url = [NSURL URLWithString:_URL];
    ASIFormDataRequest *downloadRequest = [ASIFormDataRequest requestWithURL:url]; 
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (isNeedResend) {
        //需要失败重发
        NSMutableDictionary* requestDict = [NSMutableDictionary dictionaryWithDictionary:uploadDataDict];
        [userInfo setValue:requestDict forKey:@"requestDict"];
    }
    
    [userInfo setValue:[NSNumber numberWithInt:_id] forKey:@"requestID"];
    downloadRequest.userInfo = userInfo;
    
    [downloadRequest setPostFormat:ASIMultipartFormDataPostFormat];
    downloadRequest.delegate = self;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    NSString *fileName_record = nil;
	NSString *fileName_photo = nil;
	NSString *contentType_photo = nil;
	NSString *contentType_record = nil;
	if (type == kUploadTypeRecord || type == kUploadTypeBlock){
		fileName_record = [NSString stringWithFormat:@"%f.ilbc", time];
		contentType_record = @"audio/mpeg";
	}
    
    if (type == kUploadTypePhoto || type == kUploadTypeBlock) {
        fileName_photo = [NSString stringWithFormat:@"%f.jpg", time];
        contentType_photo = @"image/jpeg";
    }
    
    //////////////// for record //////////////////////
	for (NSString *key in uploadDataDict) {
        if (![key isEqualToString:@"record"] && ![key isEqualToString:@"voice"]) {
            [downloadRequest setPostValue:[uploadDataDict objForKey:key] forKey:key];
        }
    }
    
    if ([uploadDataDict objForKey:@"record"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"record"]
                    withFileName:fileName_record
                  andContentType:contentType_record
                          forKey:@"record"];
    }else if ([uploadDataDict objForKey:@"voice"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"voice"]
                    withFileName:fileName_record
                  andContentType:contentType_record
                          forKey:@"voice"];
    }
    
    //////////////// for photo ///////////////////////
    for (NSString *key in uploadDataDict) {
        if (![key isEqualToString:@"photo"]) {
            [downloadRequest setPostValue:[uploadDataDict objForKey:key] forKey:key];
        }
    }    
    
    if ([uploadDataDict objForKey:@"photo"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"photo"] 
                    withFileName:fileName_photo 
                  andContentType:contentType_photo
                          forKey:@"photo"];        
    }
    
    if (self.queue == nil) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
        [self.queue setMaxConcurrentOperationCount:2];
    }
    
    [queue addOperation:downloadRequest];
}

- (void)postToURL:(NSString *)URL withData:(NSDictionary *)uploadDataDict requestID:(NSInteger)_id type:(NSInteger)type {
    
    [self postToURL:URL withData:uploadDataDict requestID:_id type:type needResend:NO];
    return;
    
    NSString *_URL = [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)URL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8) autorelease];
    NSURL *url = [NSURL URLWithString:_URL];
    ASIFormDataRequest *downloadRequest = [ASIFormDataRequest requestWithURL:url]; 
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_id] forKey:@"requestID"];
    downloadRequest.userInfo = userInfo;
    [downloadRequest setPostFormat:ASIMultipartFormDataPostFormat];
    downloadRequest.delegate = self;
     
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	
	NSString *fileName_record = nil;
	NSString *fileName_photo = nil;
	NSString *contentType_photo = nil;
	NSString *contentType_record = nil;
	if (type == kUploadTypeRecord || type == kUploadTypeBlock){
		fileName_record = [NSString stringWithFormat:@"%f.ilbc", time];
		contentType_record = @"audio/mpeg";
		
	} 
	
	if (type == kUploadTypePhoto || type == kUploadTypeBlock) {
		fileName_photo = [NSString stringWithFormat:@"%f.jpg", time];
		contentType_photo = @"image/jpeg";
	} 

	//////////////// for record //////////////////////
	for (NSString *key in uploadDataDict) {
        if (![key isEqualToString:@"record"] && ![key isEqualToString:@"voice"]) {
            [downloadRequest setPostValue:[uploadDataDict objForKey:key] forKey:key];
        }
    }    
	    
    if ([uploadDataDict objForKey:@"record"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"record"] 
                    withFileName:fileName_record 
                  andContentType:contentType_record
                          forKey:@"record"];        
    }else if ([uploadDataDict objForKey:@"voice"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"voice"]
                    withFileName:fileName_record
                  andContentType:contentType_record
                          forKey:@"voice"];
    }
	
	//////////////// for photo ///////////////////////
	for (NSString *key in uploadDataDict) {
        if (![key isEqualToString:@"photo"]) {
            [downloadRequest setPostValue:[uploadDataDict objForKey:key] forKey:key];
        }
    }    
	
    if ([uploadDataDict objForKey:@"photo"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"photo"] 
                    withFileName:fileName_photo 
                  andContentType:contentType_photo
                          forKey:@"photo"];        
    }
    
    if (self.queue == nil) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
        [self.queue setMaxConcurrentOperationCount:2];
    }

    [queue addOperation:downloadRequest];
}

- (void)postToURL:(NSString *)URL withData:(NSDictionary *)uploadDataDict requestName:(NSString*)_name requestType:(NSInteger)_requestType type:(NSInteger)type needResend:(BOOL)isNeedResend {
    
    NSString *_URL = [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)URL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8) autorelease];
    NSURL *url = [NSURL URLWithString:_URL];
    ASIFormDataRequest *downloadRequest = [ASIFormDataRequest requestWithURL:url]; 
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (isNeedResend) {
        //需要失败重发
        NSMutableDictionary* requestDict = [NSMutableDictionary dictionaryWithDictionary:uploadDataDict];
        [userInfo setValue:requestDict forKey:@"requestDict"];
    }
    
    [userInfo setValue:_name forKey:@"requestName"];
    [userInfo setValue:[NSNumber numberWithInt:_requestType] forKey:@"requestType"];
    downloadRequest.userInfo = userInfo;
    
    [downloadRequest setPostFormat:ASIMultipartFormDataPostFormat];
    downloadRequest.delegate = self;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	
    NSString *fileName_record = nil;
	NSString *fileName_photo = nil;
	NSString *contentType_record = nil;
	NSString *contentType_photo = nil;
    
    if (type == kUploadTypeRecord || type == kUploadTypeBlock) {
		fileName_record = [NSString stringWithFormat:@"%f.ilbc", time];
		contentType_record = @"audio/mpeg";
		
	}
	
	if (type == kUploadTypePhoto || type == kUploadTypeBlock) {
		fileName_photo = [NSString stringWithFormat:@"%f.jpg", time];
		contentType_photo = @"image/jpeg";
	}
    
    //////////////// for record //////////////////////
	for (NSString *key in uploadDataDict) {
        if (![key isEqualToString:@"record"] && ![key isEqualToString:@"voice"]) {
            [downloadRequest setPostValue:[uploadDataDict objForKey:key] forKey:key];
        }
    }
    
    if ([uploadDataDict objForKey:@"record"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"record"]
                    withFileName:fileName_record
                  andContentType:contentType_record
                          forKey:@"record"];
    }else if ([uploadDataDict objForKey:@"voice"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"voice"]
                    withFileName:fileName_record
                  andContentType:contentType_record
                          forKey:@"voice"];
    }
    
	
	//////////////// for photo ///////////////////////
	for (NSString *key in uploadDataDict) {
        if (![key isEqualToString:@"photo"]) {
            [downloadRequest setPostValue:[uploadDataDict objForKey:key] forKey:key];
        }
    }    
	
    if ([uploadDataDict objForKey:@"photo"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"photo"] 
                    withFileName:fileName_photo 
                  andContentType:contentType_photo
                          forKey:@"photo"];        
    }
    
    if (self.queue == nil) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
        [self.queue setMaxConcurrentOperationCount:2];
    }
    
    [queue addOperation:downloadRequest];
}

- (void)postToURL:(NSString *)URL withData:(NSDictionary *)uploadDataDict requestName:(NSString*)_name requestType:(NSInteger)_requestType type:(NSInteger)type {
    
    [self postToURL:URL withData:uploadDataDict requestName:_name requestType:_requestType type:type needResend:NO];
    return;
    
    NSString *_URL = [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)URL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8) autorelease];
    NSURL *url = [NSURL URLWithString:_URL];
    ASIFormDataRequest *downloadRequest = [ASIFormDataRequest requestWithURL:url]; 
    
    //NSDictionary *userInfo = [NSDictionary dictionaryWithObject:_name forKey:@"requestName"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_name, @"requestName", [NSNumber numberWithInt:_requestType], @"requestType", nil];
    downloadRequest.userInfo = userInfo;
    [downloadRequest setPostFormat:ASIMultipartFormDataPostFormat];
    downloadRequest.delegate = self;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	
    //	NSString *fileName_record = nil;
	NSString *fileName_photo = nil;
	NSString *contentType_photo = nil;
	
	if (type == kUploadTypePhoto || type == kUploadTypeBlock) {
		fileName_photo = [NSString stringWithFormat:@"%f.jpg", time];
		contentType_photo = @"image/jpeg";
	} 
	
	//////////////// for photo ///////////////////////
	for (NSString *key in uploadDataDict) {
        if (![key isEqualToString:@"photo"]) {
            [downloadRequest setPostValue:[uploadDataDict objForKey:key] forKey:key];
        }
    }    
	
    if ([uploadDataDict objForKey:@"photo"] != nil) {
        [downloadRequest addData:[uploadDataDict objForKey:@"photo"] 
                    withFileName:fileName_photo 
                  andContentType:contentType_photo
                          forKey:@"photo"];        
    }
    
    if (self.queue == nil) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
        [self.queue setMaxConcurrentOperationCount:2];
    }
    
    [queue addOperation:downloadRequest];
}


- (void)cancel {
    [queue cancelAllOperations];
}

@end
