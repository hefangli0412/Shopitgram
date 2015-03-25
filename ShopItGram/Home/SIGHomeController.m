//
//  SIGHomeController.m
//  shopitgram
//
//  Created by Hefang Li on 9/28/14.
//
//

#import "SIGHomeController.h"
#import "SIGLargeCollectionCell.h"
#import "SIGPhotoController.h"
#import "SIGCommentController.h"

#define kHomeCollectionCellIdentifier @"LargeCell"

@interface SIGHomeController()
@property (nonatomic) NSArray *postData;
@end

@implementation SIGHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SIGLargeCollectionCell" bundle:nil] forCellWithReuseIdentifier:kHomeCollectionCellIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.postData count];
}

- (SIGLargeCollectionCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{   
    SIGLargeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCollectionCellIdentifier forIndexPath:indexPath];

    [self clearCell:cell];
    
    cell.post = self.postData[indexPath.row];
    cell.viewController = self;
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    CGSize retval;
//    retval.height = 600;
//    retval.width = 320;
//    return retval;
//}

- (void)refresh
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefault objectForKey:@"Insta_accessToken"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@", accessToken];
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
