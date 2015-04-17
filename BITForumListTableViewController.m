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
        return [dict count] - 1;
    }
    else if ([[_firLevelArray objectAtIndex:[indexPath row]] isKindOfClass: NSClassFromString(@"NSArray")])
    {
        NSArray *arr =[_firLevelArray objectAtIndex:[indexPath row]];
        return [arr count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier =  @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([[_firLevelArray objectAtIndex:[indexPath row]] isKindOfClass: NSClassFromString(@"NSDictionary")]) {
        NSDictionary *dict = [_firLevelArray objectAtIndex:[indexPath row]];
        NSString* title = [dict[@"main"][@"name"] stringByDecodingURLFormat];
        cell.textLabel.text = title;
    }
    else if ([[_firLevelArray objectAtIndex:[indexPath row]] isKindOfClass: NSClassFromString(@"NSArray")])
    {
        cell.textLabel.text = @"无人区";

    }
    cell.isExpandable = YES;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if ([[_firLevelArray objectAtIndex:[indexPath row]] isKindOfClass: NSClassFromString(@"NSDictionary")]) {
        NSDictionary *dict = [_firLevelArray objectAtIndex:[indexPath row]];
        NSDictionary *subDict = [dict objectForKey:[NSString stringWithFormat:@"%d", indexPath.subRow]];
        if ([subDict[@"main"] isKindOfClass:NSClassFromString(@"NSArray")]) {
            NSDictionary *contnentDict = subDict[@"main"][0];
            cell.textLabel.text = [contnentDict[@"name"] stringByDecodingURLFormat];

        }
        
    }
    else if ([[_firLevelArray objectAtIndex:[indexPath row]] isKindOfClass: NSClassFromString(@"NSArray")])
    {
        NSArray *arr = [_firLevelArray objectAtIndex:[indexPath row]];
        
        if ([[arr objectAtIndex:indexPath.row] isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            NSDictionary *dict = [arr objectAtIndex:indexPath.row];
            NSArray *subArray = [NSArray arrayWithArray:dict[@"sub"]];
            NSDictionary *subDict = [NSDictionary dictionaryWithDictionary:subArray[indexPath.subRow]];
            cell.textLabel.text = [subDict[@"name"] stringByDecodingURLFormat];;
        }
        
    }
    

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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
//            for (NSDictionary *dict in _firLevelTitle) {
//                [_firLevelArray addObject: dict];
//            }
            NSArray *keys = [_firLevelTitle allKeys];
            for (NSString *key in keys) {
                [_firLevelArray addObject:_firLevelTitle[key]];
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

- (NSDictionary*)trimUselessInfo
{
    NSMutableDictionary *trimedDict = [NSMutableDictionary dictionary];
    for (id obj in _firLevelArray) {
        if ([obj isKindOfClass:NSClassFromString(@"NSDictionary")])
        {
            
        }
        else if ([obj isKindOfClass:NSClassFromString(@"NSArray")])
        {
            
        }
    }
}
@end
