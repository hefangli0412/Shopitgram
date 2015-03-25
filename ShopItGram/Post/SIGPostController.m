//
//  SIGPostController.m
//  shopitgram
//
//  Created by Hefang Li on 9/30/14.
//
//

#import "SIGPostController.h"
#import "SIGEditTextController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SIGAppDelegate.h"

@interface SIGPostController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@end

@implementation SIGPostController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.imageView.image == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.imageView.image = nil;
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        // TODO: go to home scene
        SIGAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SIGRootController"]];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // A photo was taken/selected!
        self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Save the image!
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
        }
    }
    else {
        NSLog(@"Wrong media type");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editText"]) {
        SIGEditTextController *viewController = (SIGEditTextController *)segue.destinationViewController;
        viewController.image = self.imageView.image;
    }
}

@end
