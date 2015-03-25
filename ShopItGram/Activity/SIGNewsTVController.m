//
//  SIGNewsTVController.m
//  shopitgram
//
//  Created by Hefang Li on 10/3/14.
//
//

#import "SIGNewsTVController.h"
#import "SIGPhotoController.h"

@interface SIGNewsTVController ()
@property (nonatomic) NSArray *dataSource;
@end

@implementation SIGNewsTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
    
    // discard unnecessary rows
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)refresh
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefault objectForKey:@"Insta_accessToken"];
    int userId = [[userDefault objectForKey:@"Insta_userId"] intValue];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/%d/followed-by?access_token=%@", userId, accessToken]; // Get the list of users this user is followed by.
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"text: %@", text);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.dataSource = [responseDictionary valueForKeyPath:@"data"];
        } else {
            self.dataSource = nil;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    [task resume];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.textLabel.text = dict[@"username"];
    cell.imageView.image = [UIImage imageNamed:@"placeholder"]; // TODO
    [SIGPhotoController profilePictureFromURL:dict[@"profile_picture"] completion:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    
    // disable the UITableView selection highlighting
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

@end
