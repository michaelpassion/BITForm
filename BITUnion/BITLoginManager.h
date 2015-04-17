//
//  BITLoginManager.h
//  BITUnion
//
//  Created by baidu on 15/4/15.
//
//

#import "AFHTTPSessionManager.h"

@interface BITLoginManager : AFHTTPSessionManager

+(BITLoginManager *)sharedBITLoginManager;

@end
