//
//  MyOrderViewController.h
//  KababjeesChanges
//
//  Created by Amerald on 06/09/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "MyOrderTableViewCell.h"
@interface MyOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mytable;

@end
