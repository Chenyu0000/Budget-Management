//
//  ViewController.m
//  Budget Management
//
//  Created by Chen Yu on 2022/5/28.
//

#import "SignInController.h"
#import "MainController.h"
@import FirebaseAuth;
@import FirebaseCore;
@import FirebaseFirestore;
@import Foundation;

@interface SignInController ()

@end

@implementation SignInController

- (IBAction)signIn:(id)sender {
    NSLog(@"trying to sign in with %@, %@", self.username.text, self.password.text);
    [[FIRAuth auth] signInWithEmail:self.username.text
                           password:self.password.text
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"successfully sign in, username is %@", self.username.text);
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSLog(@"wrong password or username");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username.text = @"test@gmail.com";
    self.password.text = @"123123";
    self.navigationItem.hidesBackButton = YES;
}


@end
