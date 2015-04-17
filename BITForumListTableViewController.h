//
//  BITForumListTableViewController.h
//  BITUnion
//
//  Created by baidu on 15/4/16.
//
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"

@interface BITForumListTableViewController : UIViewController <SKSTableViewDelegate>

@property (weak, nonatomic) IBOutlet SKSTableView *tableView;

@end
