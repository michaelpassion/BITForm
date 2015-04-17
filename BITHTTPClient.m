//
//  BITHTTPClient.m
//  BITUnion
//
//  Created by baidu on 15/4/16.
//
//

#import "BITHTTPClient.h"


static  NSString* BaseURLString = @"http://out.bitunion.org/open_api/";

@implementation BITHTTPClient

+(BITHTTPClient *)sharedBITHTTPClient
{
    static BITHTTPClient *_shardBITHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken , ^{
        _shardBITHTTPClient = [[self alloc]initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    
    return _shardBITHTTPClient;
}
-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

@end
