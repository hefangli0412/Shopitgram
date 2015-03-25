//
//  SIGActivityController.m
//  shopitgram
//
//  Created by Hefang Li on 9/30/14.
//
//

#import "SIGActivityController.h"

@interface SIGActivityController ()
@property (nonatomic) UIViewController *currentChildVC;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
-(IBAction)changeSeg;
@end

@implementation SIGActivityController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIViewController *first = [self.storyboard instantiateViewControllerWithIdentifier:@"SIGFollowingTVController"];
    [self presentChildController:first];
    
    [self changeSeg]; // there is wrong offset at the first load; this is a hotfix.
}

- (void)presentChildController:(UIViewController*)childVC
{
    //0. Remove the current Detail View Controller showed
    if (self.currentChildVC) {
        [self removeCurrentChildViewController];
    }

    //1. Add the detail controller as child of the container
    [self addChildViewController:childVC];

    //2. Define the detail controller's view size
    childVC.view.frame = [self frameForContainerController];

    //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
    [self.containerView addSubview:childVC.view];
    self.currentChildVC = childVC;

    //4. Complete the add flow calling the function didMoveToParentViewController
    [childVC didMoveToParentViewController:self];
 
}

- (void)removeCurrentChildViewController
{
    //1. Call the willMoveToParentViewController with nil
    //   This is the last method where your detailViewController can perform some operations before being removed
    [self.currentChildVC willMoveToParentViewController:nil];
    
    //2. Remove the DetailViewController's view from the Container
    [self.currentChildVC.view removeFromSuperview];
    
    //3. Update the hierarchy"
    //   Automatically the method didMoveToParentViewController: will be called on the detailViewController)
    [self.currentChildVC removeFromParentViewController];
}

- (CGRect)frameForContainerController
{
    CGRect containerFrame = self.containerView.bounds;
    return containerFrame;
}


- (void)swapCurrentControllerWith:(UIViewController*)viewController
{
    //1. The current controller is going to be removed
    [self.currentChildVC willMoveToParentViewController:nil];
    
    //2. The new controller is a new child of the container
    [self addChildViewController:viewController];
    
    //3. Setup the new controller's frame depending on the animation you want to obtain
    viewController.view.frame = CGRectMake(0, 2000, viewController.view.frame.size.width, viewController.view.frame.size.height);
    
    //3b. Attach the new view to the views hierarchy
    [self.containerView addSubview:viewController.view];
    
    [UIView animateWithDuration:0
     
     //4. Animate the views to create a transition effect
                     animations:^{
                         
                         //The new controller's view is going to take the position of the current controller's view
                         viewController.view.frame = self.currentChildVC.view.frame;
                         
                         //The current controller's view will be moved outside the window
                         self.currentChildVC.view.frame = CGRectMake(0, -2000, self.currentChildVC.view.frame.size.width, self.currentChildVC.view.frame.size.width);
                     }
     
     
     //5. At the end of the animations we remove the previous view and update the hierarchy.
                     completion:^(BOOL finished) {
                         
                         //Remove the old Detail Controller view from superview
                         [self.currentChildVC.view removeFromSuperview];
                         
                         //Remove the old Detail controller from the hierarchy
                         [self.currentChildVC removeFromParentViewController];
                         
                         //Set the new view controller as current
                         self.currentChildVC = viewController;
                         [self.currentChildVC didMoveToParentViewController:self];
                     }];
    
}

-(IBAction)changeSeg
{
    /* Mode 1 */
/*    if(self.segment.selectedSegmentIndex == 0){
        [self presentChildController:[self.storyboard instantiateViewControllerWithIdentifier:@"SIGFollowingTVController"]];
    }
    
    if(self.segment.selectedSegmentIndex == 1){
        [self presentChildController:[self.storyboard instantiateViewControllerWithIdentifier:@"SIGNewsTVController"]];
    }*/
    
    /* Mode 2 */
   if(self.segment.selectedSegmentIndex == 0){
        [self swapCurrentControllerWith:[self.storyboard instantiateViewControllerWithIdentifier:@"SIGFollowingTVController"]];
    }
    
    if(self.segment.selectedSegmentIndex == 1){
        [self swapCurrentControllerWith:[self.storyboard instantiateViewControllerWithIdentifier:@"SIGNewsTVController"]];
    }
}

@end
