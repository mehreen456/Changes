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
    BOOL find;
    NSInteger value,oldq,newq;
    int d;
}
@end

@implementation ItemDescriptionViewController
@synthesize ItemImage,ItemName,Name,ItemPrice,Price,imageUrl,Quantity,TotalPrice,ItemID,values,EQLabel,Orderquan,addbutton;

- (void)viewDidLoad {
   
    value=1; find=NO;

    self.Orderquan.hidden=YES;
    self.EQLabel.hidden=YES;
    [self ItemExist];
    
    if([TPrice isEqualToString:@"00"]||[TPrice isEqualToString:@"0"] || ItemsOrder.count==0)
    self.navigationItem.rightBarButtonItem=nil;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    tp=[Price integerValue];
    self.ItemName.text=[@"  " stringByAppendingString:Name];

    self.ItemPrice.text=[self.ItemPrice.text stringByAppendingString:Price];
       self.TotalPrice.text=self.ItemPrice.text;
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;
    
    self.ItemImage.image=[UIImage imageNamed:@"logo.png"];
    [self setcolor];
        [super viewDidLoad];
}


#pragma mark - My Methods

- (IBAction)AddToBasketButton:(UIButton *)sender {
    
    Relaod++;
    BasketItems++;
    btp=tp+[TPrice integerValue];
    TPrice=[NSString stringWithFormat:@"%2lu", (unsigned long)btp];
    
    if(!find)
    {
        NSMutableDictionary *order=[NSMutableDictionary dictionaryWithObjectsAndKeys:Name,INKey,Price, IPKey,[NSString stringWithFormat:@"%2lu", (unsigned long)value],QKey,ItemID,@"menu_id",Key ,@"uuid",  nil];
        [ItemsOrder addObject:order];
        
    }
    else
    {
        oldq=[[[ItemsOrder objectAtIndex:d]valueForKey:QKey ]integerValue];
        newq=oldq + value;

        [[ItemsOrder objectAtIndex:d] setValue:[NSString stringWithFormat:@"%ld", (long)newq] forKey:QKey];
   }
}
- (IBAction)DecButton:(id)sender {
 
    value++;
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
    self.Quantity.text =[@"Quantity" stringByAppendingString:[NSString stringWithFormat:@"%2lu", (unsigned long)value]];
    tp= [Price integerValue];
    tp= tp *value;
    self.TotalPrice.text= [@"Rs " stringByAppendingString:[NSString stringWithFormat:@"%2lu", (unsigned long)tp]];
}
-(void) ItemExist
{
    for (d=0; d<ItemsOrder.count; d++) {
        
        NSString * DishName=[[ItemsOrder objectAtIndex:d]valueForKey:INKey];
        if ([DishName isEqualToString:Name]) {
            
            self.Orderquan.text =[[ItemsOrder objectAtIndex:d]valueForKey:QKey];
            find=YES;
            break;
            
        }
        
    }
    if(find)
    {
        self.Orderquan.hidden=NO;
        self.EQLabel.hidden=NO;
    }

    

}
-(void) setcolor
{
    [self.ItemPrice setBackgroundColor: [[GlobalVariables class]color:0]];
    [self.Ib setBackgroundColor: [[GlobalVariables class]color:1]];
    [self.Db setBackgroundColor: [[GlobalVariables class]color:1]];
    [self.line setBackgroundColor: [[GlobalVariables class]color:1]];
    [self.addbutton setBackgroundColor: [[GlobalVariables class]color:0]];
    [self.Orderquan setTextColor:[[GlobalVariables class]color:1]];
    [self.EQLabel setTextColor: [[GlobalVariables class]color:1]];
}

@end
