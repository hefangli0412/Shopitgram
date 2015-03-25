//
//  SIGLaunchController.m
//  shopitgram
//
//  Created by Hefang Li on 9/28/14.
//
//

#import "SIGLoginController.h"
#import "SIGAccountAuthorization.h"
#import "SIGAppDelegate.h"

@implementation SIGLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SIGAccountAuthorization authorizeInstagramAccountAndCompletion:^{
        if ([SIGAccountAuthorization userAuthorized]) {
            [SIGAccountAuthorization loginParseAccountAndCompletion:^{
                [self resetRootController];
            }];
        }
    }];
}

- (IBAction)signinButtonPressed:(id)sender
{
    [SIGAccountAuthorization authorizeInstagramAccountAndCompletion:^{
        if ([SIGAccountAuthorization userAuthorized]) {
            [SIGAccountAuthorization loginParseAccountAndCompletion:^{
                [self resetRootController];
            }];
        }
    }];
}

- (void)resetRootController
{
    [self transitionAnimation];
    
    SIGAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SIGRootController"]];
}

- (void)transitionAnimation
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
}

@end
