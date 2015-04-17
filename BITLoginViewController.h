//
//  BITLoginViewController.h
//  BITUnion
//
//  Created by baidu on 15/4/15.
//
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "BITLoginManager.h"
#import "BITLoginHTTPClinet.h"

@interface BITLoginViewController : UIViewController

@property (nonatomic, strong) BITLoginManager *loginManager;
@property (nonatomic, strong) BITLoginHTTPClinet *loginHTTPClient;
- (IBAction)loginBtnClicked:(id)sender;
@end
