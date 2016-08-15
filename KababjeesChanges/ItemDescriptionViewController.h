//
//  ItemDescriptionViewController.h
//  Kababjee'sApp
//
//  Created by Amerald on 10/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface ItemDescriptionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *ItemPrice;
@property (strong, nonatomic) IBOutlet UILabel *EQLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ItemImage;
@property (strong, nonatomic) IBOutlet UILabel *ItemName;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *ItemID;
@property (strong, nonatomic) IBOutlet UILabel *Quantity;
@property (strong, nonatomic) IBOutlet UILabel *Orderquan;
@property (strong, nonatomic) NSString *Price;
@property (strong, nonatomic) IBOutlet UILabel *TotalPrice;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSMutableDictionary *values;
- (IBAction)AddToBasketButton:(UIButton *)sender;
- (IBAction)DecButton:(id)sender;
- (IBAction)IncButton:(id)sender;
-(void)valueChanged;
@end

