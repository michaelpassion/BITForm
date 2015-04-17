//
//  BITLoginHTTPClinet.m
//  BITUnion
//
//  Created by baidu on 15/4/15.
//
//

#import "BITLoginHTTPClinet.h"

static  NSString* BaseURLString = @"http://out.bitunion.org/open_api/";

@implementation BITLoginHTTPClinet

+(BITLoginHTTPClinet *)sharedBITHTTPClient
{
    static BITLoginHTTPClinet *_shardBITLoginHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shardBITLoginHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    
    return _shardBITLoginHTTPClient;
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
