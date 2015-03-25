//
//  SIGLeftMenuController.h
//  shopitgram
//
//  Created by Hefang Li on 9/30/14.
//
//

#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>

@interface SIGLeftMenuController : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>

@property (nonatomic, strong) NSArray *childVCs;

@end
