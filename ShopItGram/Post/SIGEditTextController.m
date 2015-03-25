//
//  SIGEditTextController.m
//  shopitgram
//
//  Created by Hefang Li on 10/3/14.
//
//

#import "SIGEditTextController.h"
#import <Parse/Parse.h>

@interface SIGEditTextController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)accept:(id)sender;
@end

@implementation SIGEditTextController

- (IBAction)accept:(id)sender
{
    if (self.image == nil || [self.textView.text length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again!"
                                                            message:@"Please capture or select a photo to share and add some description!"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [self uploadMessage];
        // TODO: go back to menu
    }
}

#pragma mark - Helper methods

- (void)uploadMessage
{
    NSData *photoData;
    NSString *photoName;
    NSString *textMessage;
    
    UIImage *newPhoto = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
    photoData = UIImagePNGRepresentation(newPhoto);
    photoName = @"image.png";
    textMessage = self.textView.text;
    
    PFFile *photo = [PFFile fileWithName:photoName data:photoData];
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                message:@"Please try sending your photo again."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            PFObject *post = [PFObject objectWithClassName:@"Post"];
            post[@"photo"] = photo;
            post[@"message"] = textMessage;
            post[@"author"] = [[PFUser currentUser] username];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                        message:@"Please try sending your message again."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    // Everything was successful!
                    [self showPostCompletion];
                }
            }];
        }
    }];
}

// This is to reduce the image size considering the storage of Parse.com
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (void)showPostCompletion
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Posted!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

#pragma mark - resign keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([_textView isFirstResponder] && [touch view] != _textView) {
        [_textView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - textField placeholder

- (void)viewDidLoad
{
    self.imageView.image = self.image;

    self.textView.delegate = self;
    self.textView.text = @"say something about your product...";
    self.textView.textColor = [UIColor lightGrayColor]; //optional
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"say something about your product..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"say something about your product...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

@end
