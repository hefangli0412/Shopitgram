//
//  SIGRootController.m
//  shopitgram
//
//  Created by Hefang Li on 9/30/14.
//
//

#import "SIGRootController.h"
#import "SIGLeftMenuController.h"

@interface SIGRootController ()

@end

@implementation SIGRootController

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    SIGLeftMenuController *leftVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SIGLeftMenuController"];
    leftVC.childVCs = @[[self.storyboard instantiateViewControllerWithIdentifier:@"SIGHomeController"],
                        [self.storyboard instantiateViewControllerWithIdentifier:@"SIGExploreController"],
                        [self.storyboard instantiateViewControllerWithIdentifier:@"SIGPostController"],
                        [self.storyboard instantiateViewControllerWithIdentifier:@"SIGActivityController"],
                        [self.storyboard instantiateViewControllerWithIdentifier:@"SIGProfileController"]];
    self.leftMenuViewController = leftVC;
    self.contentViewController = [[UINavigationController alloc] initWithRootViewController:leftVC.childVCs[0]];
    self.rightMenuViewController = nil;
    self.backgroundImage = [UIImage imageNamed:@"MenuBG"];
}

@end
