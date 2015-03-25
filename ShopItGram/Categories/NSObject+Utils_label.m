//
//  NSObject+Utils_label.m
//  shopitgram
//
//  Created by Hefang Li on 10/4/14.
//
//

#import "NSObject+Utils_label.h"

@implementation NSObject (Utils_label)

-  (CGSize) calculateLabelHeightWithWidth:(CGFloat)width text:(NSString*)textString fontSize:(CGFloat)fontSize
{
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont systemFontOfSize:fontSize]; // Your Font-style whatever you want to use.
    gettingSizeLabel.text = textString;
    gettingSizeLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(width, 9999); // this width will be as per your requirement
    CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    return expectedSize;
}

@end
