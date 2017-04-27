//
//  Requester.m
//  Aireleven
//
//  Created by SungJu on 2017. 3. 3..
//  Copyright © 2017년 Aireleven. All rights reserved.
//

#import "Requester.h"
#import "NetworkManager.h"

#define DEFAULT_CONTENTTYPE                 @"application/json"
#define TIME_OUT                            60.0f

@interface Requester ()

@property (nonatomic, retain) NSString*             url;
@property (nonatomic, retain) NSDictionary*         bodyData;
@property (nonatomic, retain) NSString*             bodyString;
@property (nonatomic, retain) NSMutableDictionary*  headerMap;
@property (nonatomic, retain) NSString*             contentType;
@property (nonatomic, assign) kConnectionType       connectionType;
@property (nonatomic, assign) float                 timeout;

@end

@implementation Requester

- (instancetype)initWithUrl:(NSString*)url connectionType:(kConnectionType)connectionType;
{
    self = [super init];
    if (self) {
        _url = url;
        _connectionType = connectionType;
        _timeout = TIME_OUT;
        _contentType = DEFAULT_CONTENTTYPE;
        _headerMap = [NSMutableDictionary new];
        _bodyData = [NSDictionary new];
    }
    return self;
}

- (void)setContentType:(NSString *)contentType
{
    _contentType = contentType;
}

- (void)setNetworkTimeout:(NSInteger)timeout
{
    _timeout = timeout;
}

- (void)setHeader:(NSDictionary*)header
{
    [_headerMap setDictionary:header];
}

- (void)setBodyWithDict:(NSDictionary*)body
{
    _bodyData = body;
}

- (void)setBodyWithString:(NSString*)str{
    _bodyString = str;
}

- (void)sendRequest:(void (^)(NSDictionary* ret))completionHandler
{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]
                                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                             timeoutInterval:_timeout];
    
    [request addValue:_contentType forHTTPHeaderField:@"Content-Type"];
    
    for ( NSString *key in [_headerMap allKeys] ) {
        [request addValue:[_headerMap objectForKey:key] forHTTPHeaderField:key];;
    }
//
    [request setHTTPMethod:[self getConnectionType]];
    
    NSData *postData;
    if(_bodyString.length > 0){
        postData = [_bodyString dataUsingEncoding:NSUTF8StringEncoding];
    }else if(_bodyData){
        postData = [NSJSONSerialization dataWithJSONObject:_bodyData options:0 error:nil];
    }
    if(postData){
        [request setHTTPBody:postData];
    }
    
    NSLog(@"==========================================================");
    NSLog(@"URL : %@",_url);
    NSLog(@"HEADER : %@",_headerMap);
    NSLog(@"BODY String : %@",_bodyString);
    NSLog(@"BODY Data : %@",postData);
    NSLog(@"==========================================================");
    [[NetworkManager sharedInstance] sendRequest:request completionHandler:completionHandler];
    
}

- (NSString*)getConnectionType
{
    NSString * ret = @"";
    switch (_connectionType) {
        case kConnectionType_GET:
            ret = @"GET";
            break;
            
        case kConnectionType_POST:
            ret = @"POST";
            break;
            
        case kConnectionType_PUT:
            ret = @"PUT";
            break;
            
        case kConnectionType_DELETE:
            ret = @"DELETE";
            break;
            
        default:
            ret = @"POST";
            break;
    }
    
    return ret;
}

@end
