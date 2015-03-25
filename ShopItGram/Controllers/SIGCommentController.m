//
//  SIGCommentController.m
//  shopitgram
//
//  Created by Hefang Li on 9/30/14.
//
//

#import "SIGCommentController.h"

@implementation SIGCommentController

+ (void)setCommentLabel:(STTweetLabel*)label fromPost:(NSDictionary*)post
{
    // clean label text first; "cell.commentLabel.text = nil;" does not work
    [label setText:@""];
    
    if ([post[@"caption"]isKindOfClass:[NSNull class]]) {
        return;
    }

    label.text = post[@"caption"][@"text"];
    label.userInteractionEnabled = YES;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [label setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
        
        switch (hotWord) {
            case STTweetHandle:
                // TODO: search for mention
                NSLog(@"%@ : %@", hotWords[hotWord], string);
                break;
            case STTweetHashtag:
                // TODO: search for hashtag
                NSLog(@"%@ : %@", hotWords[hotWord], string);
                break;
            default:
                break;
        }
        
    }];
}

@end
