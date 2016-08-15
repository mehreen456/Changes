//
//  MenuItemsViewController.h
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItems.h"
#import "GlobalVariables.h"
#import "MyTableViewCell.h"

@interface MenuItemsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *menuTable;
@property (nonatomic,strong) NSMutableArray * JsonRes;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (nonatomic,strong) NSMutableArray * CImage;
-(void) retriveData;
-(void) basket;
-(void) show;
-(void) EmptyArray;
@end
