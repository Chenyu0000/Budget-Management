//
//  ItemAddController.m
//  Budget Management
//
//  Created by Chen Yu on 2022/5/31.
//

#import "ItemAddController.h"
@import FirebaseAuth;
@import FirebaseCore;
@import FirebaseFirestore;

@interface ItemAddController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *preferenceField;
@property (weak, nonatomic) IBOutlet UITextField *urlField;

@end

@implementation ItemAddController
- (IBAction)handleTapAddButton:(id)sender {
    FIRUser *user = [FIRAuth auth].currentUser;
    if (!user) {
        NSLog(@"not signed in");
        return;
    }
    NSString* uid = user.uid;

    FIRFirestore *db = [FIRFirestore firestore];
    if ([self.titleText  isEqual: @"Bought Items"]){
        FIRCollectionReference * current_budget = [[[db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"budget"];
        [[[current_budget documentWithPath: self.month] collectionWithPath:@"bought"] addDocumentWithData:@{
            @"url": self.urlField.text,
            @"price": @([self.priceField.text intValue]),
            @"name":self.nameField.text,
            @"preference":@([self.preferenceField.text intValue]),
          } completion:^(NSError * _Nullable error) {
            if (error != nil) {
              NSLog(@"Error adding document: %@", error);
            } else {
              NSLog(@"Document added with ID: %@", uid);
            }
            [self.delegate sendFetchData];
            [self.navigationController popViewControllerAnimated:YES];
          }];
    }else{
        FIRCollectionReference* wishListRef = [[[db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"wishlist"];
        [wishListRef addDocumentWithData:@{
            @"url": self.urlField.text,
            @"price": @([self.priceField.text intValue]),
            @"name":self.nameField.text,
            @"preference":@([self.preferenceField.text intValue]),
          } completion:^(NSError * _Nullable error) {
            if (error != nil) {
              NSLog(@"Error adding document: %@", error);
            } else {
              NSLog(@"Document added with ID: %@", uid);
            }
            [self.delegate sendFetchData];
            [self.navigationController popViewControllerAnimated:YES];
          }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = self.titleText;
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
