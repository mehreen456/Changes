//
//  GlobalVariables.m
//  Kababjee'sApp
//
//  Created by Amerald on 02/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "GlobalVariables.h"

NSString *CID = @" ", *CTitle = @" ", *TPrice = @" ";
NSString *Key=@"e6b4777d-7edd-4622-aba7-a7b2c12b4630", *DataType=@"application/json",*CType=@"Content-Type",*Authorization=@"Authorization";
NSString *NKey=@"name",*IdKey=@"category_id",*DesKey=@"description",*PKey=@"price",*ImgKey=@"images",*UKey=@"url",*INKey=@"item_name",*QKey=@"quantity",*IPKey=@"item_price",*IKey=@"id",*BaseUrl= @"http://olo.dmenu.co:3003/api/v1";
NSMutableArray * ItemsOrder= nil,*MenuArray=nil;
NSUInteger btp=0;
int *BasketItems=0, *Relaod=0;

@implementation GlobalVariables


+(UIButton*) BarButton
{
    
    UIButton *basket = [UIButton buttonWithType:UIButtonTypeSystem];
    basket.backgroundColor = [UIColor clearColor];
    [basket setImage:[UIImage imageNamed:@"basket"] forState:UIControlStateNormal];
    [basket setTitle:[@"  Rs " stringByAppendingString:TPrice] forState:UIControlStateNormal];
    basket.titleLabel.font=[UIFont systemFontOfSize:16];
    basket.titleLabel.minimumScaleFactor = 0.5f;
    [basket.titleLabel sizeToFit];
    basket.tintColor = [UIColor whiteColor];
    [basket setTranslatesAutoresizingMaskIntoConstraints:YES];
    basket.autoresizesSubviews = YES;
    basket.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
    return basket;

}
+(UILabel *) Title:(NSString *) showtitle 
{
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0 ,150,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.text = showtitle;
    lbNavTitle.textColor = [UIColor whiteColor];
    lbNavTitle.font=[UIFont systemFontOfSize:20];
    lbNavTitle.minimumScaleFactor = 0.5f;
    [lbNavTitle sizeToFit];
    
    return lbNavTitle;
}

@end
