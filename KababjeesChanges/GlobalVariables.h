//
//  GlobalVariables.h
//  Kababjee'sApp
//
//  Created by Amerald on 02/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "CategoriesViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ItemDescriptionViewController.h"
#import "BasketViewController.h"
#import "DejalActivityView.h"
#import "MenuItemsViewController.h"
#import "UIView+Toast.h"


extern NSString *CID,*CTitle,*TPrice,*Key,*DataType,*MenuUrl,*CatUrl,*CType,*Authorization,*NKey,*IdKey,*DesKey,*PKey,*IKey,*UKey,*OrderUrl,*INKey,*QKey,*IPKey,*ImgKey,*BaseUrl,*OP;
extern int *BasketItems,*Relaod,*LoadData;
extern  NSUInteger btp;
extern NSMutableArray *ItemsOrder,*MenuArray,*Torders;
extern BOOL Running,showmenu;
extern  NSUserDefaults *defaults;

@interface GlobalVariables : NSObject

+(UIButton *) BarButton;
+(NSString *) Title:(NSString *) showtitle ;
+(UIColor *) color:(int) c;
+(UIToolbar *) done :(UIView *) view;
@end
