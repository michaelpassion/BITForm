//
//  BITThreadDetailTableViewCell.m
//  BITUnion
//
//  Created by baidu on 15/4/21.
//
//

#import "BITThreadDetailTableViewCell.h"
#import "NSString+DecodeURLString.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"

@interface BITThreadDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation BITThreadDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([[self.messageDict allKeys] count]) {
            self.usernameLabel.text = [_messageDict[@"author"] stringByDecodingURLFormat];
            NSString *avatar = [_messageDict[@"avatar"] stringByDecodingURLFormat];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:avatar]];
            
            self.timeLabel.text = [_messageDict[@"dateline"] stringByDecodingURLFormat];
            
            __weak typeof(self) weakself = self;
            [weakself.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakself.imageView.image = image;
                [weakself setNeedsLayout];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"request avatar error");
            }];
        }

    }
        return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
