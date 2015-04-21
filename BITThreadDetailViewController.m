//
//  BITThreadDetailViewController.m
//  BITUnion
//
//  Created by baidu on 15/4/21.
//
//

#import "BITThreadDetailViewController.h"
#import "BITHTTPClient.h"
#import "BITCommenTools.h"
#import "NSString+DecodeURLString.h"
#import "BITThreadDetailViewController.h"
#import "BITThreadDetailTableViewCell.h"

static NSString* cellIdentifier = @"cellIdentifer";

@interface BITThreadDetailViewController()
{
    EGORefreshTableHeaderView *egoRefreshTableHeaderView;
    BOOL isRefreshing;
    
    LoadMoreTableFooterView *loadMoreTableFooterView;
    BOOL isLoadMoreing;
    int rowsCount;
}

@property(nonatomic,strong) NSMutableArray *threadDetailList;

@end

@implementation BITThreadDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    rowsCount = 20;
    isRefreshing = NO;
    
    UINib *nib = [UINib nibWithNibName:@"BITThreadDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    if (egoRefreshTableHeaderView == nil)
    {
        egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height )];
        egoRefreshTableHeaderView.delegate = self;
        [self.tableView addSubview:egoRefreshTableHeaderView];
    }
    [egoRefreshTableHeaderView refreshLastUpdatedDate];
    
    if (loadMoreTableFooterView == nil)
    {
        loadMoreTableFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        loadMoreTableFooterView.delegate = self;
        [self.tableView addSubview:loadMoreTableFooterView];
    }
    
    [self getTHreadDetailListFromServer];
//    [self.navigationController.navigationItem.leftBarButtonItem setStyle:UIBarButtonSystemItemRedo];

}
- (void)reloadData
{
    [self.tableView reloadData];
    loadMoreTableFooterView.frame = CGRectMake(0.0f,  self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
}

- (void)getTHreadDetailListFromServer
{
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];

    BITHTTPClient *httpClient = [BITHTTPClient sharedBITHTTPClient];
    NSDictionary *parameters = @{@"action":@"post",
                                 @"username":[defaultUser valueForKey:@"username"],
                                 @"session":[defaultUser valueForKey:@"session"],
                                 @"tid":[self valueForKey:@"tid"],
                                 @"from":@(rowsCount-20),
                                 @"to":@(rowsCount)
                                 };
    [httpClient POST:@"bu_post.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result1 = [NSDictionary dictionaryWithDictionary:[BITCommenTools retriveDictionaryFromData:responseObject]];
        if ([result1[@"result"] isEqualToString:@"success"]) {
            
            if ([[NSArray arrayWithArray:result1[@"postlist"]] count] <= 0) {
                return ;
            }
            self.threadDetailList = [NSMutableArray arrayWithArray:result1[@"postlist"]];
            [self reloadData];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"retrive data error" message:result1[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error :");
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.threadDetailList count];
}

- (BITThreadDetailTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BITThreadDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BITThreadDetailTableViewCell alloc] init];
    }
    NSDictionary *dict = [self.threadDetailList objectAtIndex:[indexPath row]];
    
    cell.messageDict = [NSDictionary dictionaryWithDictionary:dict];
    return cell;
}


#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [loadMoreTableFooterView loadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [loadMoreTableFooterView loadMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    isRefreshing = YES;
    NSLog(@"%d",rowsCount);
    rowsCount -= 20;
    if (rowsCount < 20) {
        rowsCount = 20;
        return;
    }
    [self getTHreadDetailListFromServer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // waiting for loading data from internet
        sleep(2);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //complete refreshing
            isRefreshing = NO;
            [self reloadData];
            [egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}


-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return isRefreshing;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view
{
    isLoadMoreing = YES;
    rowsCount += 20; // add 20 more records
    [self getTHreadDetailListFromServer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // waiting for loading data from internet
        sleep(2);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // complete loading...
            isLoadMoreing = NO;
            
            [loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return isLoadMoreing;
}

@end
