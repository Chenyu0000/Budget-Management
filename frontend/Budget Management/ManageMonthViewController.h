//
//  ManageMonthViewController.h
//  Budget Management
//
//  Created by Chen Yu on 2022/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol sendMonthDelegate <NSObject>
- (void)sendSelectedMonth:(NSString*)month;
@end

@interface ManageMonthViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addMonth;
@property (weak, nonatomic) IBOutlet UITableView *monthTable;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;
@property (nonatomic) id <sendMonthDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
