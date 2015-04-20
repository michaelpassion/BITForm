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

@interface BITSubFormListTableViewController ()
@property (nonatomic, strong) NSMutableArray *threadList;
@end

@implementation BITSubFormListTableViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getMessageWithFid];
    self.navigationController.navigationItem.title = [self valueForKey:@"title"];
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
                                 @"from":@0,
                                 @"to":@20};
    [httpClient POST:@"bu_thread.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result1 = [NSDictionary dictionaryWithDictionary:[BITCommenTools retriveDictionaryFromData:responseObject]];
        if ([result1[@"result"] isEqualToString:@"success"]) {
        self.threadList = [NSMutableArray arrayWithArray:result1[@"threadlist"]];
        }
        [self.tableView reloadData];

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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"view %@ | replices %@", dict[@"views"],dict[@"replies"]];
    return cell;
}
@end
