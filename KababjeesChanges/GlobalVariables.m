//
//  GlobalVariables.m
//  Kababjee'sApp
//
//  Created by Amerald on 02/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "GlobalVariables.h"

NSString *CID = @" ", *CTitle = @" ", *TPrice = @" ",*OP;
NSString *Key=@"042e96b6-31cb-4746-b139-3d3e70bdf137", *DataType=@"application/json",*CType=@"Content-Type",*Authorization=@"Authorization";
NSString *NKey=@"name",*IdKey=@"category_id",*DesKey=@"description",*PKey=@"price",*ImgKey=@"images",*UKey=@"url",*INKey=@"item_name",*QKey=@"quantity",*IPKey=@"item_price",*IKey=@"id",*BaseUrl= @"http://olo.dmenu.co:3002/api/v1";
NSMutableArray * ItemsOrder= nil,*MenuArray=nil,*Torders=nil;
NSUInteger btp=0;
NSUserDefaults *defaults;
int *BasketItems=0, *Relaod=0 ,*LoadData;
BOOL Running=NO,showmenu=NO;
// Production:@"042e96b6-31cb-4746-b139-3d3e70bdf137" 3002
//@"e6b4777d-7edd-4622-aba7-a7b2c12b4630" 3003
@implementation GlobalVariables


+(UIButton*) BarButton
{
    
    UIButton *basket = [UIButton buttonWithType:UIButtonTypeSystem];
    basket.backgroundColor = [UIColor clearColor];
    [basket setImage:[UIImage imageNamed:@"basket"] forState:UIControlStateNormal];
    [basket setTitle:[@" Rs " stringByAppendingString:TPrice] forState:UIControlStateNormal];
    basket.titleLabel.font=[UIFont systemFontOfSize:16];
    basket.titleLabel.minimumScaleFactor = 0.4f;
    [basket.titleLabel sizeToFit];
    basket.tintColor = [UIColor whiteColor];
    [basket setTranslatesAutoresizingMaskIntoConstraints:YES];
    basket.autoresizesSubviews = YES;
    basket.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
    return basket;

}
+(NSString *) Title:(NSString *) showtitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    [label setFont:[UIFont boldSystemFontOfSize:20.0]];
    [label setText:showtitle];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    
    NSString *mystr;
    mystr=label.text;
    return mystr;
}

+(UIColor *) color:(int) c
{
    UIColor *mycolor;
    if(c==1)
    mycolor=[UIColor colorWithRed:124/255.0f green:175/255.0f blue:65/255.0f alpha:1.0f];
    else
    mycolor=[UIColor colorWithRed:215/255.0f green:8/255.0f blue:13/255.0f alpha:1.0f];

    return mycolor;

}
+(UIToolbar *) done :(UIView *) view
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:view action:@selector(endEditing:)];
    doneBarButton.tintColor=[UIColor grayColor];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    
    return keyboardToolbar;
}

+(NSString *) systime
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy hh:mma";
    dateFormatter.locale=[NSLocale localeWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:now];
}

@end
