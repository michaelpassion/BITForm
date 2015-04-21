//
//  BITThreadDetailViewController.h
//  BITUnion
//
//  Created by baidu on 15/4/21.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"


@interface BITThreadDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) NSString *tid;

@end
