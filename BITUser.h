//
//  BITUser.h
//  BITUnion
//
//  Created by baidu on 15/4/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BITUser : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * session;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * credit;
@property (nonatomic, retain) NSString * lastactivity;
@property (nonatomic, retain) NSNumber * result;

@end
