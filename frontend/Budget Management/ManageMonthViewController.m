//
//  ManageMonthViewController.m
//  Budget Management
//
//  Created by Chen Yu on 2022/5/30.
//

#import "ManageMonthViewController.h"
@import FirebaseAuth;
@import FirebaseCore;
@import FirebaseFirestore;
#import "MainController.h"
@interface ManageMonthViewController ()
@property FIRFirestore *db;
@property NSMutableArray *months;

@end

@implementation ManageMonthViewController
- (IBAction)addMonth:(id)sender {
    FIRUser *user = [FIRAuth auth].currentUser;
    if (!user) {
        NSLog(@"not signed in");
        return;
    }
    NSString* uid = user.uid;
    FIRFirestore *db = [FIRFirestore firestore];
    FIRCollectionReference * current_budget = [[[db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"budget"];
    [[current_budget documentWithPath: self.monthTextField.text] setData:@{
        @"total": @([self.budgetTextField.text intValue]),
        @"current": @([self.budgetTextField.text intValue]),
      } completion:^(NSError * _Nullable error) {
        if (error != nil) {
          NSLog(@"Error adding document: %@", error);
        } else {
          NSLog(@"Document added with ID: %@", uid);
        }
        
        [[[current_budget documentWithPath: self.monthTextField.text] collectionWithPath:@"bought"] addDocumentWithData:@{
            @"url": @"",
            @"price": @0,
            @"name":@"placeholder",
            @"preference":@0,
          } completion:^(NSError * _Nullable error) {
            if (error != nil) {
              NSLog(@"Error adding document: %@", error);
            } else {
              NSLog(@"Document added with ID: %@", uid);
            }
          }];
        [self fetchData];
      }];
}

- (FIRCollectionReference*) getBudgetCollectionRef {
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString* uid = user.uid;
    FIRCollectionReference* budgetRef = [[[self.db collectionWithPath:@"budget-management"] documentWithPath:uid] collectionWithPath:@"budget"];
    return budgetRef;
}

- (void) fetchData {
    self.months = [NSMutableArray arrayWithCapacity:100];
    FIRCollectionReference* budgetRef = [self getBudgetCollectionRef];
    // update bugget and month
    [budgetRef getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (error != nil) {
              NSLog(@"Error getting documents: %@", error);
            } else {
              for (FIRDocumentSnapshot *document in snapshot.documents) {
                  NSLog(@"%@", document.documentID);
                  [self.months addObject:document.documentID];
              }
            }
            [self.monthTable reloadData];
        }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    self.monthTextField.text = dateString;
    self.budgetTextField.text = @"1500";
    
    self.db = [FIRFirestore firestore];
    [self fetchData];
    
    
    self.monthTable.dataSource = self;
    self.monthTable.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.months.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)section {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"monthCell"];
    cell.textLabel.text = self.months[section.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate sendSelectedMonth:self.months[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    return;
}
@end
