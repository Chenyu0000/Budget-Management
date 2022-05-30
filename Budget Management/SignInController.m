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
            MainController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"main"];
            UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:vc];
            navBar.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:navBar animated:YES completion:nil];
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            MainController *myNewVC = (MainController *)[storyboard instantiateViewControllerWithIdentifier:@"main"];
//            [self.navigationController pushViewController:myNewVC animated:YES];
            
        }else{
            NSLog(@"wrong password or username");
        }
    }];
    
    
//    [[FIRAuth auth] createUserWithEmail:self.username.text
//                               password:self.password.text
//                             completion:^(FIRAuthDataResult * _Nullable authResult,
//                                          NSError * _Nullable error) {
//    }];
}
//- (IBAction)upload_budget:(id)sender {
//    FIRUser *user = [FIRAuth auth].currentUser;
//    if (!user) {
//        NSLog(@"not signed in");
//        return;
//    }
//    NSString* uid = user.uid;
//    FIRFirestore *db = [FIRFirestore firestore];
//    [[[[[db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"budget"] documentWithPath: @"2022-05"] setData:@{
//        @"original": @2500,
//        @"current": @2500
//      } completion:^(NSError * _Nullable error) {
//        if (error != nil) {
//          NSLog(@"Error adding document: %@", error);
//        } else {
//          NSLog(@"Document added with ID: %@", uid);
//        }
//      }];
////    FIRCollectionReference *messageRef =
////        [[[db collectionWithPath:@"budget"] documentWithPath:uid]
////        collectionWithPath:@"2022-05"];
////    __block FIRDocumentReference *ref1 =
////        [messageRef addDocumentWithData:@{
////
////        } completion:^(NSError * _Nullable error) {
////          if (error != nil) {
////            NSLog(@"Error adding document: %@", error);
////          } else {
////            NSLog(@"Document added with ID: %@", ref1.documentID);
////          }
////        }];
//}
//- (IBAction)upload_bought_item:(id)sender {
//    FIRUser *user = [FIRAuth auth].currentUser;
//    if (!user) {
//        NSLog(@"not signed in");
//        return;
//    }
//    NSString* uid = user.uid;
//    
//    FIRFirestore *db = [FIRFirestore firestore];
//    FIRCollectionReference * current_budget = [[[db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"budget"];
//    [[[current_budget documentWithPath: @"2022-05"] collectionWithPath:@"bought"] addDocumentWithData:@{
//        @"url": @"https://www.amazon.com/dp/B0796RCTMT/?coliid=I39GCPKMXCNX1L&colid=32R1W59E0VC5F&ref_=lv_cv_lig_dp_it&th=1",
//        @"price": @100,
//        @"name":@"table",
//        @"preference":@58.99,
//      } completion:^(NSError * _Nullable error) {
//        if (error != nil) {
//          NSLog(@"Error adding document: %@", error);
//        } else {
//          NSLog(@"Document added with ID: %@", uid);
//        }
//      }];
//}
//
//- (IBAction)upload_plan:(id)sender {
//    FIRUser *user = [FIRAuth auth].currentUser;
//    if (!user) {
//        NSLog(@"not signed in");
//        return;
//    }
//    NSString* uid = user.uid;
//    
//    FIRFirestore *db = [FIRFirestore firestore];
//    FIRCollectionReference * plan = [[[db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"wishlist"];
//    [plan addDocumentWithData:@{
//        @"url": @"https://www.amazon.com/dp/B08JQ97KJ6/?coliid=I3FS5N7VPJY6R2&colid=32R1W59E0VC5F&ref_=lv_cv_lig_dp_it&th=1",
//        @"price": @45.99,
//        @"name":@"Led",
//        @"preference":@2,
//      } completion:^(NSError * _Nullable error) {
//        if (error != nil) {
//          NSLog(@"Error adding document: %@", error);
//        } else {
//          NSLog(@"Document added with ID: %@", uid);
//        }
//      }];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username.text = @"test@gmail.com";
    self.password.text = @"123123";
}


@end
