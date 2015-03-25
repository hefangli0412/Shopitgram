//
//  SIGAuthorizeInstagramAccount.m
//  shopitgram
//
//  Created by Hefang Li on 9/29/14.
//
//

#import "SIGAccountAuthorization.h"
#import <SimpleAuth/SimpleAuth.h>
#import <Parse/Parse.h>

@implementation SIGAccountAuthorization

+ (void)authorizeInstagramAccountAndCompletion:(void(^)())completion
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    __block NSString *accessToken = [userDefault objectForKey:@"Insta_accessToken"];
    
    if (accessToken == nil) {
        [SimpleAuth authorize:@"instagram"
                      options: @{@"scope": @[@"likes",@"comments",@"relationships"]}
                   completion:^(NSDictionary *responseObject, NSError *error) {
                       NSString *userId = responseObject[@"uid"];
                       accessToken = responseObject[@"credentials"][@"token"];
                       [userDefault setObject:accessToken forKey:@"Insta_accessToken"];
                       [userDefault setObject:userId forKey:@"Insta_userId"];
                       [userDefault synchronize];
                       
                       completion();
                   }];
    } else {
        completion();
    }
}

+ (BOOL)userAuthorized
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefault objectForKey:@"Insta_accessToken"];
    
    return (accessToken != nil);
}

+ (void)loginParseAccountAndCompletion:(void(^)())completion
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefault objectForKey:@"Insta_accessToken"];

    // I do not need to save password to userDefault so I do not encode it.
    NSString *password = @"12345";
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (error) {
            PFUser *newUser = [PFUser user];
            newUser.username = username;
            newUser.password = password;
            
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    NSLog(@"signed up to Parse.com");
                    completion();
                }
            }];
        }
        else {
            NSLog(@"logged in to Parse.com");
            completion();
        }
    }];
}

@end
