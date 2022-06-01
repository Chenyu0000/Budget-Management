//
//  ItemAddController.h
//  Budget Management
//
//  Created by Chen Yu on 2022/5/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol fetchDataDelegate <NSObject>
- (void)sendFetchData;
@end

@interface ItemAddController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSString* titleText;
@property NSString* month;
@property (nonatomic) id <fetchDataDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
