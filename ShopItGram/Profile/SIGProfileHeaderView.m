//
//  SIGProfileHeaderView.m
//  shopitgram
//
//  Created by Hefang Li on 10/5/14.
//
//

#import "SIGProfileHeaderView.h"

@implementation SIGProfileHeaderView

-(IBAction)changeSeg
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(320.0, 250.0);
    
    NSInteger index = self.segment.selectedSegmentIndex;
    if(index == 0)
    {
        layout.itemSize = CGSizeMake(320.0, 500.0);
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
    
        self.profileVC.isLarge = YES;
    } else if (index == 1)
    {
        layout.itemSize = CGSizeMake(106.0, 106.0);
        layout.minimumInteritemSpacing = 1.0;
        layout.minimumLineSpacing = 1.0;
        
        self.profileVC.isLarge = NO;
    }
    
    [self.profileVC.collectionView setCollectionViewLayout:layout animated:NO];
    [self.profileVC.collectionView reloadData];
    [self.profileVC.collectionView setContentOffset:CGPointMake(0, -64.0f) animated:NO];
}

@end
