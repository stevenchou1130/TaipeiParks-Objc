//
//  ParkProvider.h
//  TaipeiParks-Objc
//
//  Created by steven.chou on 2017/5/30.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkModel.h"

@interface ParkProvider : NSObject

+(instancetype)sharedInstance;

-(void)getParkDataWithLimitNum:(int)limitNum withOffsetNum:(int)offsetNum;

-(NSMutableArray<ParkModel *> *)parseParkJSON: (NSData *)data;

@end
