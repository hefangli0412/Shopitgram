//
//  SIGProfileController.m
//  shopitgram
//
//  Created by Hefang Li on 10/5/14.
//
//

#import "SIGProfileController.h"
#import "SIGLargeCollectionCell.h"
#import "SIGSmallCollectionCell.h"
#import "SIGPhotoController.h"
#import "SIGCommentController.h"
#import "SIGProfileHeaderView.h"

#define kProfileLargeCellIdentifier @"LargeCell"
#define kProfileSmallCellIdentifier @"SmallCell"
#define kProfileHeaderCellIdentifier @"SIGProfileHeaderView"

@interface SIGProfileController ()
@property (nonatomic) NSArray *postData;
@property (nonatomic) NSDictionary *userData;
@end

@implementation SIGProfileController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self downloadUserInfo];
    [self downloadUserPosts];
    
    self.isLarge = YES;

    [self.collectionView registerNib:[UINib nibWithNibName:@"SIGLargeCollectionCell" bundle:nil] forCellWithReuseIdentifier:kProfileLargeCellIdentifier];
    [self.collectionView registerClass:[SIGSmallCollectionCell class] forCellWithReuseIdentifier:kProfileSmallCellIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.postData count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLarge) {
        SIGLargeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProfileLargeCellIdentifier forIndexPath:indexPath];
        
        [self clearCell:cell];
        
        cell.post = self.postData[indexPath.row];
        cell.viewController = self;
        return cell;
    } else {
        SIGSmallCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProfileSmallCellIdentifier forIndexPath:indexPath];
        
        cell.post = self.postData[indexPath.row];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SIGProfileHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                         UICollectionElementKindSectionHeader withReuseIdentifier:kProfileHeaderCellIdentifier forIndexPath:indexPath];
    headerView.username.text = self.userData[@"username"];
    headerView.followedByCount.text = [NSString stringWithFormat:@"%@",self.userData[@"counts"][@"followed_by"]];
    headerView.followsCount.text = [NSString stringWithFormat:@"%@",self.userData[@"counts"][@"follows"]];
    headerView.mediaCount.text = [NSString stringWithFormat:@"%@",self.userData[@"counts"][@"media"]];
//    headerView.bio.text = self.userData[@"bio"];
    headerView.bio.text = @"placeholder of biography placeholder of biography placeholder of biography placeholder of biography";
//    [headerView.bio sizeToFit];
    headerView.profileVC = self;
    [SIGPhotoController profilePictureFromURL:self.userData[@"profile_picture"] completion:^(UIImage *image) {
        UIImageView *v = headerView.profile_picture;
        v.layer.cornerRadius = v.frame.size.height /2;
        v.layer.masksToBounds = YES;
        v.image = image;
    }];
    return headerView;
}

#pragma mark - retrieve data

- (void)downloadUserInfo
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefault objectForKey:@"Insta_accessToken"];
    NSString *userId = [userDefault objectForKey:@"Insta_userId"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/%@/?access_token=%@", userId, accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"text: %@", text);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.userData = [responseDictionary valueForKeyPath:@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];
}

- (void)downloadUserPosts
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefault objectForKey:@"Insta_accessToken"];
    NSString *userId = [userDefault objectForKey:@"Insta_userId"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@", userId, accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"text: %@", text);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.postData = [responseDictionary valueForKeyPath:@"data"];
        } else {
            self.postData = nil;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    }];
    [task resume];
}

#pragma mark helper methods
- (void)clearCell:(SIGLargeCollectionCell *)cell
{
    cell.photo.image = nil;
    [cell.author.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


@end
