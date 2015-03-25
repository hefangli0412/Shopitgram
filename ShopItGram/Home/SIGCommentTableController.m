//
//  SIGCommentController.m
//  shopitgram
//
//  Created by Hefang Li on 10/3/14.
//
//

#import "SIGCommentTableController.h"
#import "SIGPhotoController.h"
#import "NSObject+Utils_label.h"

#define kImageLength 45

@implementation SIGCommentTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // discard unnecessary rows
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([self.post[@"caption"]isKindOfClass:[NSNull class]]) {
            return 0;
        } else {
            return 1;
        }
    } else {
        return MIN(8,[self.post[@"comments"][@"count"] intValue]);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *dict;
    if (indexPath.section == 0) {
        dict = self.post[@"caption"];
    } else {
        dict = self.post[@"comments"][@"data"][indexPath.row];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"WhitePlaceHolder"];
    [SIGPhotoController profilePictureFromURL:dict[@"from"][@"profile_picture"] completion:^(UIImage *image) {
        cell.imageView.image = image;
    }];

    cell.textLabel.text = dict[@"text"];
    
    // disable the UITableView selection highlighting
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

@end

