//
//  SIGProfileHeaderView.h
//  shopitgram
//
//  Created by Hefang Li on 10/5/14.
//
//

#import <UIKit/UIKit.h>
#import "SIGProfileController.h"

@interface SIGProfileHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *mediaCount;
@property (weak, nonatomic) IBOutlet UILabel *followsCount;
@property (weak, nonatomic) IBOutlet UILabel *followedByCount;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UIImageView *profile_picture;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) SIGProfileController *profileVC;
@end
