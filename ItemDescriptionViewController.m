//
//  ItemDescriptionViewController.m
//  Kababjee'sApp
//
//  Created by Amerald on 10/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "ItemDescriptionViewController.h"

@interface ItemDescriptionViewController ()
{
    NSUInteger tp;
    NSInteger value;
}
@end

@implementation ItemDescriptionViewController
@synthesize ItemImage,ItemName,Name,ItemPrice,Price,imageUrl,Quantity,TotalPrice,ItemID,values,EQLabel;

- (void)viewDidLoad {
   
    value=1;
    self.Quantity.hidden=YES;
    self.EQLabel.hidden=YES;
    if([TPrice isEqualToString:@"00"]||[TPrice isEqualToString:@"0"] || ItemsOrder.count==0)
        self.navigationItem.rightBarButtonItem=nil;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    tp=[Price integerValue];
    self.ItemName.text=[@"  " stringByAppendingString:Name];

    self.ItemPrice.text=[self.ItemPrice.text stringByAppendingString:Price];
    self.TotalPrice.text=self.ItemPrice.text;
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@" "];
    __weak UIImageView *weakimage = self.ItemImage;
    [self.ItemImage setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakimage.image=image;
                                   } failure:nil];
    
    
    [super viewDidLoad];
}


#pragma mark - My Methods

- (IBAction)AddToBasketButton:(UIButton *)sender {
    
    BOOL find=NO;
    Relaod++;
    BasketItems++;
    btp=tp+btp;
    TPrice=[NSString stringWithFormat:@"%2lu", (unsigned long)btp];
    for (int d=0; d<ItemsOrder.count; d++) {
        
        NSString * DishName=[[ItemsOrder objectAtIndex:d]valueForKey:INKey];
        if ([DishName isEqualToString:Name]) {
        NSInteger oldq=[[[ItemsOrder objectAtIndex:d]valueForKey:QKey ]integerValue];
            NSInteger newq=oldq + value;
            [[ItemsOrder objectAtIndex:d] setValue:[NSString stringWithFormat:@"%ld", (long)newq] forKey:QKey];
            find=YES;
            break;
        }
        
    }
    if(!find)
    {
           NSMutableDictionary *order=[NSMutableDictionary dictionaryWithObjectsAndKeys:Name,INKey,Price, IPKey,self.Quantity.text,QKey,ItemID,@"menu_id",Key ,@"uuid",  nil];
        [ItemsOrder addObject:order];
    }
   }

- (IBAction)DecButton:(id)sender {
 
    value++;
    self.EQLabel.hidden=NO;
    self.Quantity.hidden=NO;

    [self valueChanged];
}

- (IBAction)IncButton:(id)sender {
   
    if(value>1)
    {
    value--;
    [self valueChanged];
    }
}

-(void)valueChanged
{
    self.Quantity.text = [NSString stringWithFormat:@"%2lu", (unsigned long)value];
    tp= [Price integerValue];
    tp= tp *value;
    self.TotalPrice.text= [@"Rs " stringByAppendingString:[NSString stringWithFormat:@"%2lu", (unsigned long)tp]];
}
@end
