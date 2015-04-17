//
//  BITLoginViewController.m
//  BITUnion
//
//  Created by baidu on 15/4/15.
//
//

#import "BITLoginViewController.h"
#import "BITUser.h"
#import "BITForumListTableViewController.h"
#import "BITHTTPClient.h"

@interface BITLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation BITLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginHTTPClient = [BITLoginHTTPClinet sharedBITHTTPClient];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)logout:(id)sender {
    BITHTTPClient *_sharedHTTPClient = [BITHTTPClient sharedBITHTTPClient];
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"action":@"logout",
                                 @"username":[_userDefaults valueForKey:@"username"],
                                 @"password":[_userDefaults valueForKey:@"password"],
                                 @"session":[_userDefaults valueForKey:@"session"]};
    [_sharedHTTPClient POST:@"bu_logging.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"");
    }];
}

- (IBAction)loginBtnClicked:(id)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"action"] = @"login";
    parameters[@"username"] = self.usernameTF.text;;
    parameters[@"password"] = self.passwordTF.text;
    
    [self.loginHTTPClient POST:@"bu_logging.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSData *message = (NSData*)responseObject;
        NSError *error;
        NSDictionary *userLoginMessage = [NSJSONSerialization JSONObjectWithData:message options:NSJSONReadingAllowFragments error:&error];
        if([userLoginMessage[@"result"] isEqualToString:@"success"])
        {
            NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
            
            [userDefaluts setObject:userLoginMessage[@"username"] forKey:@"username"];
            [userDefaluts setObject:self.passwordTF.text forKey:@"password"];
            [userDefaluts setObject:userLoginMessage[@"session"] forKey:@"session"];
            [userDefaluts setObject:userLoginMessage[@"credit"] forKey:@"credit"];
            [userDefaluts setObject:userLoginMessage[@"lastactivity"] forKey:@"lastactivity"];
            [userDefaluts setObject:userLoginMessage[@"uid"] forKey:@"uid"];
            
            [self performSegueWithIdentifier:@"toFourmList" sender:self];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Convert User's Data" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];

    } ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

@end
