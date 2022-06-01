//
//  WishItemDetailController.m
//  Budget Management
//
//  Created by Chen Yu on 2022/5/31.
//

#import "WishItemDetailController.h"
@import FirebaseAuth;
@import FirebaseCore;
@import FirebaseFirestore;

@interface WishItemDetailController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *preferenceField;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property FIRFirestore *db;
@property NSString* name;
@property NSNumber* price;
@property NSNumber* preference;
@property FIRDocumentReference* wishItemtRef;
@property NSString* url;
@property NSString* uid;
@end

@implementation WishItemDetailController
- (IBAction)handleDeleteWishItem:(id)sender {
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString* uid = user.uid;
    FIRDocumentReference* wishItemtRef = [[[[self.db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"wishlist"] documentWithPath:self.itemId];
    [wishItemtRef deleteDocumentWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
          NSLog(@"Error removing document: %@", error);
        } else {
          NSLog(@"Document successfully removed!");
        }
        [self.delegate sendFetchData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)handleMoveWishItem:(id)sender {
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString* uid = user.uid;
    [self.wishItemtRef getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        self.price = snapshot.data[@"price"];
        self.name = snapshot.data[@"name"];
        self.preference = snapshot.data[@"preference"];
        self.url = snapshot.data[@"url"];
        
        FIRCollectionReference * current_budget = [[[self.db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"budget"];
        [[[current_budget documentWithPath: self.month] collectionWithPath:@"bought"] addDocumentWithData:@{
            @"url": self.url,
            @"price": self.price,
            @"name":self.name,
            @"preference":self.preference,
          } completion:^(NSError * _Nullable error) {
            if (error != nil) {
              NSLog(@"Error adding document: %@", error);
            } else {
              NSLog(@"Document added with ID: %@", uid);
            }
            [self.wishItemtRef deleteDocument];
            [self.delegate sendFetchData];
            [self.navigationController popViewControllerAnimated:YES];
          }];
    }];
}

- (IBAction)handleEditWishItem:(id)sender {
    [self.wishItemtRef setData:@{
        @"url": self.urlField.text,
        @"price": @([self.priceField.text intValue]),
        @"name":self.nameField.text,
        @"preference":@([self.preferenceField.text intValue]),
      } completion:^(NSError * _Nullable error) {
        if (error != nil) {
          NSLog(@"Error adding document: %@", error);
        } else {
          NSLog(@"Document updated with ID: %@", self.uid );
        }
        [self.delegate sendFetchData];
        [self.navigationController popViewControllerAnimated:YES];
      }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [FIRFirestore firestore];
    FIRUser *user = [FIRAuth auth].currentUser;
    self.uid = user.uid;
    self.wishItemtRef = [[[[self.db collectionWithPath:@"budget-management"] documentWithPath:self.uid] collectionWithPath:@"wishlist"] documentWithPath:self.itemId];
    [self.wishItemtRef getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        self.priceField.text = [snapshot.data[@"price"] stringValue];
        self.nameField.text = snapshot.data[@"name"];
        self.preferenceField.text = [snapshot.data[@"preference"] stringValue];
        self.urlField.text = snapshot.data[@"url"];
    }];
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
