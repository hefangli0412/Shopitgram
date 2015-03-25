//
//  SIGImageLabelView.m
//  shopitgram
//
//  Created by Hefang Li on 9/29/14.
//
//

#import "SIGImageLabelView.h"

#define kSpace 5

@implementation SIGImageLabelView

- (void)setImage:(UIImage*)image withImageSize:(CGFloat)length andString:(NSString*)string withStringSize:(CGFloat)fontSize
{
    CGFloat scalePara = image.size.width / length;
    UIImage *scaledImage = [UIImage imageWithCGImage:[image CGImage]
                                               scale:(image.scale * scalePara)
                                         orientation:(image.imageOrientation)];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:scaledImage];
    // make a UIImage to a circle form
    myImageView.layer.cornerRadius = myImageView.frame.size.height /2;
    myImageView.layer.masksToBounds = YES;
    myImageView.layer.borderWidth = 0;
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.text = string;
    myLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    myLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    myLabel.backgroundColor = [UIColor clearColor];
    [myLabel sizeToFit];
    [myLabel setCenter:CGPointMake(length+myLabel.frame.size.width/2+kSpace, length/2)];
    
    CGRect myFrame = myLabel.frame;
    myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, length+myLabel.frame.size.width+kSpace, length);
    [self addSubview:myImageView];
    [self addSubview:myLabel];
    self.backgroundColor = [UIColor clearColor];
}

@end
