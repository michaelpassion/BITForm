//
//  BITCommenTools.m
//  BITUnion
//
//  Created by baidu on 15/4/16.
//
//

#import "BITCommenTools.h"

@implementation BITCommenTools

+ (NSDictionary *)retriveDictionaryFromData:(NSData *)responseObject
{
    NSData *message = (NSData*)responseObject;
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:message options:NSJSONReadingAllowFragments error:&error];
    
    return dict;
}


@end
