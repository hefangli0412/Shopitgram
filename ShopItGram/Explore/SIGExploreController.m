//
//  SIGExploreController.m
//  shopitgram
//
//  Created by Hefang Li on 10/3/14.
//
//

#import "SIGExploreController.h"
#import "SIGSmallCollectionCell.h"
#import "SIGPhotoController.h"
#import "SIGProfileController.h"

#define kExploreCollectionCellIdentifier @"collectionCell"

@interface SIGExploreController ()
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSMutableArray *userSearchArray;
@property (nonatomic) NSMutableArray *hashtagSearchArray;
@property (nonatomic) NSMutableArray *productSearchArray;
@property (nonatomic) NSMutableArray *filteredResultArray;
@property IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSArray *collectionViewData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation SIGExploreController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[SIGSmallCollectionCell class] forCellWithReuseIdentifier:kExploreCollectionCellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefault objectForKey:@"Insta_accessToken"];
    
    [self refresh];
}

- (void)refresh
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/popular?access_token=%@", self.accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"text: %@", text);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.collectionViewData = [responseDictionary valueForKeyPath:@"data"];
        } else {
            self.collectionViewData = nil;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    }];
    [task resume];
}

#pragma mark - collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SIGSmallCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kExploreCollectionCellIdentifier forIndexPath:indexPath];
    
    cell.post = self.collectionViewData[indexPath.row];
    
    return cell;
}

#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredResultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *dict = self.filteredResultArray[indexPath.row];
    NSInteger index = self.searchBar.selectedScopeButtonIndex;
    switch (index) {
        case 0:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            {cell.textLabel.text = dict[@"username"];
            cell.imageView.image = [UIImage imageNamed:@"WhitePlaceHolder"];
            [SIGPhotoController profilePictureFromURL:dict[@"profile_picture"] completion:^(UIImage *image) {
                cell.imageView.image = image;
            }];
            cell.detailTextLabel.text = dict[@"full_name"];
            break;}
    
        case 1:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"#%@",dict[@"name"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d posts",(int)dict[@"media_count"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        
        default:
            // TODO
            break;
    }
    
    return cell;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if ([scope isEqualToString:@"Hashtags"]) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/search?q=%@&access_token=%@", searchText, self.accessToken];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            if (data) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                self.filteredResultArray = [responseDictionary valueForKeyPath:@"data"];
            } else {
                self.filteredResultArray = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
            
        }];
        [task resume];
    } else if ([scope isEqualToString:@"Users"]) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&access_token=%@", searchText, self.accessToken];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            if (data) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                self.filteredResultArray = [responseDictionary valueForKeyPath:@"data"];
            } else {
                self.filteredResultArray = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
            
        }];
        [task resume];
    } else {    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = self.searchBar.selectedScopeButtonIndex;
    switch (index) {
        case 0:
//            [self performSegueWithIdentifier:@"showUserProfile" sender:tableView];
            break;
            
        case 1:
            // TODO:
            break;
            
        default:
            // TODO
            break;
    }
}

#pragma mark - Segue

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showUserProfile"]) {
        SIGProfileController *userProfileVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        userProfileVC.userId = self.filteredResultArray[indexPath.row][@"id"];
    }
}*/

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.collectionView.hidden = YES;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.collectionView.hidden = NO;
}


@end
