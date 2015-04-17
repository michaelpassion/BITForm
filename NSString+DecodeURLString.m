//
//  NSString+DecodeURLString.m
//  BITUnion
//
//  Created by baidu on 15/4/17.
//
//

#import "NSString+DecodeURLString.h"

@implementation NSString (DecodeURLString)

-(NSString*)stringByDecodingURLFormat
{
    if ([(NSString *)self isEqualToString:@""]) return @"";
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end

