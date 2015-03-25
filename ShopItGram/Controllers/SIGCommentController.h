//
//  SIGCommentController.h
//  shopitgram
//
//  Created by Hefang Li on 9/30/14.
//
//

#import <Foundation/Foundation.h>
#import "STTweetLabel.h"

@interface SIGCommentController : NSObject

+ (void)setCommentLabel:(STTweetLabel*)label fromPost:(NSDictionary*)post;

@end
