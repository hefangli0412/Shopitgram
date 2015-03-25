//
//  SIGLargeCollectionCell.m
//  shopitgram
//
//  Created by Hefang Li on 9/28/14.
//
//

#import "SIGLargeCollectionCell.h"
#import "SIGPhotoController.h"
#import "SIGCommentController.h"
#import "SIGCommentTableController.h"

@interface SIGLargeCollectionCell()
@end

@implementation SIGLargeCollectionCell

- (void)setPost:(NSDictionary *)post
{
    _post = post;
    
    // set photo image
    [SIGPhotoController imageForPost:_post size:@"standard_resolution" completion:^(UIImage *image) {
        self.photo.image = image;
    }];
    
    // set username label
    NSString *username = post[@"user"][@"username"];
    [SIGPhotoController profilePictureFromURL:post[@"user"][@"profile_picture"] completion:^(UIImage *image) {
        [self.author setImage:image withImageSize:35.0f andString:username withStringSize:15.0f];
    }];

    // set detail label
    [SIGCommentController setCommentLabel:self.commentLabel fromPost:post];
    
    if ([post[@"user_has_liked"] intValue] == 1) {
        self.likeButton.imageView.image = [UIImage imageNamed:@"Liked"];
        self.liked = YES;
    } else {
        self.liked = NO;
    }

}

- (IBAction)comment:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SIGCommentTableController *commentVC = [storyboard instantiateViewControllerWithIdentifier:@"SIGCommentTableController"];
    commentVC.post = self.post;
    [self.viewController.navigationController pushViewController:commentVC animated:YES];
}

- (IBAction)like
{    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Insta_accessToken"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@",  self.post[@"id"], accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    if (self.liked) {
        request.HTTPMethod = @"DELETE";
    } else {
        request.HTTPMethod = @"POST";
    }
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.liked) {
                self.liked = !self.liked;
                self.likeButton.imageView.image = [UIImage imageNamed:@"Like"];
            } else {
                self.liked = !self.liked;
                self.likeButton.imageView.image = [UIImage imageNamed:@"Liked"];
            }
        });
        
    }];
    [task resume];
}

@end








