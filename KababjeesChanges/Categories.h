//
//  Categories.h
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject

@property(nonatomic,strong) NSString * CId;
@property(nonatomic,strong) NSString * CName;
-(id) initWithCId: (NSString *) cid andCName: (NSString *) cname;
@end
