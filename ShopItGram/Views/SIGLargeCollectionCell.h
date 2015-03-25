//
//  SIGLargeCollectionCell.h
//  shopitgram
//
//  Created by Hefang Li on 9/28/14.
//
//

#import <UIKit/UIKit.h>
#import "SIGImageLabelView.h"
#import "STTweetLabel.h"
#import "SIGHomeController.h"

@interface SIGLargeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet SIGImageLabelView *author;
@property (weak, nonatomic) IBOutlet SIGImageLabelView *passedTime;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet STTweetLabel *commentLabel;

@property (weak, nonatomic) UIViewController *viewController;
@property (nonatomic) BOOL liked;
@property (nonatomic) NSDictionary *post;

@end
