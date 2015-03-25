//
//  PhotoController.h
//  Photo Bombers
//
//  Created by Hefang Li on 8/22/14.
//  Copyright (c) 2014 hfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIGPhotoController : NSObject

+ (void)imageForPost:(NSDictionary *)post size:(NSString *)size completion:(void(^)(UIImage *image))completion;
+ (void)profilePictureFromURL:(NSString *)urlString completion:(void(^)(UIImage *image))completion;

@end
