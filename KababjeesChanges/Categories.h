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
@property(nonatomic,strong) NSString * BId;
@property(nonatomic,strong) NSString * BName;
@property(nonatomic,strong) NSString * BCode;


-(id) initWithCId: (NSString *) cid andCName: (NSString *) cname;
-(id) initWithBId: (NSString *) bid andBName: (NSString *) bname andCode: (NSString *) bcode;

@end
