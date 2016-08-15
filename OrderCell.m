//
//  OrderCell.m
//  Kababjee'sApp
//
//  Created by Amerald on 16/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell
@synthesize OrderLabel=_OrderLabel;
@synthesize OrderPriceLabel=_OrderPriceLabel;
@synthesize Quantity=_Quantity;
@synthesize BView;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)DButton:(id)sender {
    
   
    
}
@end
