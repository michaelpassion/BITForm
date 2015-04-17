//
//  BITLoginHTTPClinet.h
//  BITUnion
//
//  Created by baidu on 15/4/15.
//
//

#import "AFHTTPSessionManager.h"

@protocol BITHTTPClientDelegate;

@interface BITLoginHTTPClinet : AFHTTPSessionManager

@property(nonatomic,weak) id<BITHTTPClientDelegate> delegate;

+(BITLoginHTTPClinet *)sharedBITHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;

@end
