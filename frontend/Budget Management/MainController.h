//
//  MainController.h
//  Budget Management
//
//  Created by Chen Yu on 2022/5/30.
//

#import <UIKit/UIKit.h>
#import "ManageMonthViewController.h"
#import "ItemAddController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainController : UIViewController <UITableViewDelegate, UITableViewDataSource, sendMonthDelegate, fetchDataDelegate>
@property (weak, nonatomic) IBOutlet UILabel *budget;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property NSString* monthData;
@end

NS_ASSUME_NONNULL_END
