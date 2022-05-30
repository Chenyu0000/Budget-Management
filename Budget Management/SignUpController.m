//
//  SignUpController.m
//  Budget Management
//
//  Created by Chen Yu on 2022/5/29.
//
#import "SignInController.h"
#import "SignUpController.h"
@import FirebaseAuth;
@import FirebaseCore;
@import FirebaseFirestore;
@import Foundation;
@interface SignUpController ()

@end

@implementation SignUpController
- (IBAction)createUser:(id)sender {
    NSLog(@"trying to sign in with %@, %@", self.username.text, self.password.text);
    [[FIRAuth auth] createUserWithEmail:self.username.text
                           password:self.password.text
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"successfully sign up, username is %@", self.username.text);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"wrong password or username");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
