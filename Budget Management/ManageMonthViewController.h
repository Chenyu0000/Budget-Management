//
//  ManageMonthViewController.h
//  Budget Management
//
//  Created by Chen Yu on 2022/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManageMonthViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addMonth;
@property (weak, nonatomic) IBOutlet UITableView *monthTable;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;

@end

NS_ASSUME_NONNULL_END
