//
//  BITForumListTableViewController.m
//  BITUnion
//
//  Created by baidu on 15/4/16.
//
//

#import "BITForumListTableViewController.h"
#import "BITHTTPClient.h"
#import "BITCommenTools.h"
#import "NSString+DecodeURLString.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "BITSubFormCell.h"
#import "BITSubFormListTableViewController.h"

@interface BITForumListTableViewController ()

@property (nonatomic, strong) NSDictionary* formDict;
@property (nonatomic, strong) NSDictionary* firLevelTitle;
@property (nonatomic, strong) NSDictionary* secLevelTitle;
@property (nonatomic, strong) NSMutableArray *firLevelArray;

@end

@implementation BITForumListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"北理FTP联盟·移动版 ";
    [self getformList];
    self.tableView.SKSTableViewDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SubFormSegue"] &&
        [segue.destinationViewController isKindOfClass:NSClassFromString(@"BITSubFormListTableViewController")]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        BITSubFormCell *cell = (BITSubFormCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        BITSubFormListTableViewController* dest = segue.destinationViewController;
        [dest setValue:cell.fid forKey:@"fid"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:NSClassFromString(@"SKSTableViewCell")]) {
        return;
    }
    [self performSegueWithIdentifier:@"SubFormSegue" sender: self.tableView.indexPathForSelectedRow];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_firLevelArray count];
}
- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_firLevelArray objectAtIndex:[indexPath row]] isKindOfClass:NSClassFromString(@"NSDictionary")] ) {
        NSDictionary *dict = [_firLevelArray objectAtIndex:[indexPath row]];
        NSArray *keys = [dict allKeys];
        NSInteger rows = [keys count];
        return rows - 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier =  @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if ([[_firLevelArray objectAtIndex:[indexPath row]] isKindOfClass: NSClassFromString(@"NSDictionary")]) {
        NSDictionary *dict = [_firLevelArray objectAtIndex:[indexPath row]];
        NSString* title = [dict[@"main"][@"name"] stringByDecodingURLFormat];
        cell.textLabel.text = title;
    }
   
    cell.isExpandable = YES;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BITSubFormCell";
    
    BITSubFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[BITSubFormCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if ([[_firLevelArray objectAtIndex:[indexPath row]] isKindOfClass: NSClassFromString(@"NSDictionary")]) {
        NSDictionary *dict = [_firLevelArray objectAtIndex:[indexPath row]];
        NSDictionary *subDict = [dict objectForKey:[NSString stringWithFormat:@"%li",[indexPath subRow]-1]];
        
        if ([subDict[@"main"] isKindOfClass:NSClassFromString(@"NSArray")]) {
            NSDictionary *contnentDict = subDict[@"main"][0];
            cell.textLabel.text = [contnentDict[@"name"] stringByDecodingURLFormat];
#warning 在线人数本地化
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"在线人数: %@",[contnentDict[@"onlines"] stringByDecodingURLFormat] ];
            cell.detailTextLabel.text =[contnentDict[@"description"] stringByDecodingURLFormat];
            cell.fid = [contnentDict[@"fid"] stringByDecodingURLFormat];
        }
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSComparisonResult)compare:(NSString *)other
{
    return [(NSString *)self compare:other] == NSOrderedDescending;
}
# pragma mark - retrive data

- (NSDictionary *)getformList
{
    BITHTTPClient* _sharedHTTPClient = [BITHTTPClient sharedBITHTTPClient];
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"action":@"forum",
                                 @"username":[defaultUser objectForKey:@"username"],
                                 @"session":[defaultUser objectForKey:@"session"] };
    NSDictionary *result = nil;
    [_sharedHTTPClient POST:@"bu_forum.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
         _formDict = [NSDictionary dictionaryWithDictionary:[BITCommenTools retriveDictionaryFromData:responseObject]];
        if ([_formDict[@"result"] isEqualToString:@"success"]) {
            _firLevelTitle = [NSDictionary dictionaryWithDictionary:_formDict[@"forumslist"]];
            _firLevelArray = [NSMutableArray array];
            NSArray *keys = [[_firLevelTitle allKeys]  sortedArrayUsingSelector:@selector(compare:)];
            for (NSString *key in keys) {
                if (![key isEqualToString:@""]) {
                    [_firLevelArray addObject:_firLevelTitle[key]];
                }
            }
            [self.tableView reloadData];
        }
        else
        {
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"fail");
    }];
    
    return result;
}

- (NSDictionary*)modifyMessageDict
{
    NSMutableDictionary *trimedDict = [NSMutableDictionary dictionary];
    NSArray *keys = _firLevelArray;
    
    for (NSString* key in keys) {
        if ([_firLevelTitle[key] isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            trimedDict[key] = _firLevelTitle[key];
        }
    }
    
    return trimedDict;
}
@end
