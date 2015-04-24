//
//  BITThreadDetailTableViewCell.h
//  BITUnion
//
//  Created by baidu on 15/4/21.
//
//

#import <UIKit/UIKit.h>

@interface BITThreadDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *messageDict;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webContent;

@end
