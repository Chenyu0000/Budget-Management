//
//  MainController.m
//  Budget Management
//
//  Created by Chen Yu on 2022/5/30.
//

#import "SignInController.h"
#import "MainController.h"
#import "ManageMonthViewController.h"
@import FirebaseAuth;
@import FirebaseCore;
@import FirebaseFirestore;

@interface MainController ()
@property FIRFirestore *db;
@property NSNumber* currentBudget;
@property NSNumber* totalBudget;
@property NSMutableArray* wishList;
@property (weak, nonatomic) IBOutlet UITableView *boughtTableView;
@property (weak, nonatomic) IBOutlet UITableView *wishlistTableView;

@end

@implementation MainController

- (IBAction)handleTapManageMonth:(id)sender {
    ManageMonthViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"manageMonth"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FIRUser *user = [FIRAuth auth].currentUser;
    if (!user) {
        NSLog(@"not signed in");
        SignInController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"signin"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    self.db = [FIRFirestore firestore];
    [self fetchData];
    self.boughtTableView.delegate = self;
    self.wishlistTableView.delegate = self;
    self.boughtTableView.dataSource = self;
    self.wishlistTableView.dataSource = self;
}

//- (void)getMultipleAll {
//  // [START get_multiple_all]
//  [[self.db collectionWithPath:@"cities"]
//      getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
//        if (error != nil) {
//          NSLog(@"Error getting documents: %@", error);
//        } else {
//          for (FIRDocumentSnapshot *document in snapshot.documents) {
//            NSLog(@"%@ => %@", document.documentID, document.data);
//          }
//        }
//      }];
//  // [END get_multiple_all]
//}

- (FIRCollectionReference*) getBudgetCollectionRef {
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString* uid = user.uid;
    FIRCollectionReference* budgetRef = [[[self.db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"budget"];
    return budgetRef;
}

- (void) fetchData {
    FIRCollectionReference* budgetRef = [self getBudgetCollectionRef];
    // update bugget and month
    [budgetRef getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (error != nil) {
              NSLog(@"Error getting documents: %@", error);
            } else {
              for (FIRDocumentSnapshot *document in snapshot.documents) {
                  if (self.monthData && self.monthData != document.documentID) {
                      continue;
                  }
                  self.currentBudget = document.data[@"current"];
                  self.totalBudget = document.data[@"total"];
                  self.monthData = document.documentID;
                  self.month.text = self.monthData;
                  self.budget.text = [NSString stringWithFormat:@"$%@/$%@", [self.currentBudget stringValue], [self.totalBudget stringValue] ];
                  break;
              }
            }
        }];
}
- (void)sendSelectedMonth:(NSString*) month {
    self.monthData = month;
    [self fetchData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.boughtTableView) {
        return 3;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)section {
    if (tableView == self.boughtTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"boughtCell"];
        cell.textLabel.text = @"bought Item";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wishlistCell"];
        cell.textLabel.text = @"wishlist";
        return cell;
    }
//    cell.textLabel.text = self.months[section.row];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
