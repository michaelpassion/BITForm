//
//  BITLoginManager.m
//  BITUnion
//
//  Created by baidu on 15/4/15.
//
//

#import "BITLoginManager.h"

@implementation BITLoginManager

+(BITLoginManager *)sharedBITLoginManager
{
    static BITLoginManager *_sharedBITLoginManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBITLoginManager = [[self alloc]init];
    });
    
    return _sharedBITLoginManager;
}
@end
