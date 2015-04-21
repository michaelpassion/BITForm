//
//  BITSubFormListTableViewController.m
//  BITUnion
//
//  Created by baidu on 15/4/20.
//
//

#import "BITSubFormListTableViewController.h"
#import "BITLoginManager.h"
#import "BITHTTPClient.h"
#import "BITCommenTools.h"
#import "NSString+DecodeURLString.h"
#import "BITThreadDetailViewController.h"

@interface BITSubFormListTableViewController ()
{
    EGORefreshTableHeaderView *egoRefreshTableHeaderView;
    BOOL isRefreshing;
    
    LoadMoreTableFooterView *loadMoreTableFooterView;
    BOOL isLoadMoreing;
    
    int dataRows;
}
@property (nonatomic, strong) NSMutableArray *threadList;
@property (nonatomic, strong) NSString *tid;


@end

@implementation BITSubFormListTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.title = [self valueForKey:@"title"];
    isRefreshing = NO;
    dataRows = 20;
    
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
    
    [self getMessageWithFid];
}

- (void)reloadData
{
    [self.tableView reloadData];
    loadMoreTableFooterView.frame = CGRectMake(0.0f,  self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
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
    NSLog(@"%d",dataRows);
    dataRows -= 20;
    if (dataRows < 20) {
        dataRows = 20;
        return;
    }
    [self getMessageWithFid];

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
    dataRows += 20; // add 20 more records
    [self getMessageWithFid];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // waiting for loading data from internet
        sleep(2);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // complete loading...
            isLoadMoreing = NO;
            
            [self reloadData];
            
            [loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}
 - (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return isLoadMoreing;
}
         

- (void)getMessageWithFid
{
    BITHTTPClient *httpClient = [BITHTTPClient sharedBITHTTPClient];
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];

    NSString *fid = [self valueForKey:@"fid"];
    NSDictionary *parameters = @{@"action":@"thread",
                                 @"username":[defaultUser objectForKey:@"username"],
                                 @"session":[defaultUser objectForKey:@"session"],
                                 @"fid":fid,
                                 @"from":@(dataRows-20),
                                 @"to":@(dataRows)};
    [httpClient POST:@"bu_thread.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result1 = [NSDictionary dictionaryWithDictionary:[BITCommenTools retriveDictionaryFromData:responseObject]];
        if ([result1[@"result"] isEqualToString:@"success"]) {
            self.threadList = [NSMutableArray arrayWithArray:result1[@"threadlist"]];
        [self reloadData];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"retrive data error" message:result1[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"fail");
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.threadList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString* Identifier = @"ThreadListIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    
    NSDictionary *dict = [self.threadList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [dict[@"subject"] stringByDecodingURLFormat];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"number%li view %@ | replices %@",dataRows + [indexPath row], dict[@"views"],dict[@"replies"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (![[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:NSClassFromString(@"BITThreadDetailViewController")]) {
//        return;
//    }
    NSDictionary *cellMessage = [self.threadList objectAtIndex:[indexPath row]];
    self.tid = cellMessage[@"tid"];
    [self performSegueWithIdentifier:@"threadDetailSegue" sender: self.tableView.indexPathForSelectedRow];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"threadDetailSegue"]) {
        if ([segue.destinationViewController isKindOfClass:NSClassFromString(@"BITThreadDetailViewController")]) {
            BITThreadDetailViewController *threadDetailVC = segue.destinationViewController;
            [threadDetailVC setValue:self.tid forKey:@"tid"];
        }
    }
}
@end
