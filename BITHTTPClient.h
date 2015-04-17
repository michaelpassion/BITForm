//
//  BITHTTPClient.h
//  BITUnion
//
//  Created by baidu on 15/4/16.
//
//

#import "AFHTTPSessionManager.h"

@protocol BITHTTPClientDelegate;

@interface BITHTTPClient : AFHTTPSessionManager
@property(nonatomic,weak) id<BITHTTPClientDelegate> delegate;

+(BITHTTPClient *)sharedBITHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;

@end
