//
//  OrderCell.h
//  Kababjee'sApp
//
//  Created by Amerald on 16/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasketViewController.h"
@interface OrderCell : UITableViewCell <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *OrderLabel;
@property (strong, nonatomic) IBOutlet UITextField *Quantity;
@property (strong, nonatomic) IBOutlet UILabel *OrderPriceLabel;
@property (strong, nonatomic) IBOutlet UIView *BView;

@end
