//
//  WishItemDetailController.h
//  Budget Management
//
//  Created by Chen Yu on 2022/5/31.
//

#import <UIKit/UIKit.h>
#import "ItemAddController.h"
NS_ASSUME_NONNULL_BEGIN

@interface WishItemDetailController : UIViewController
@property NSString* month;
@property NSString* itemId;
@property (nonatomic) id <fetchDataDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
