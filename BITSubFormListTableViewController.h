//
//  BITSubFormListTableViewController.h
//  BITUnion
//
//  Created by baidu on 15/4/20.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@interface BITSubFormListTableViewController : UITableViewController<EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>

@property(nonatomic,assign)NSString *fid;
@end
