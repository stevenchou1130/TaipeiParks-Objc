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

+(instancetype _Nullable )sharedInstance;

-(void)getParkDataWithLimitNum:(int)limitNum withOffsetNum:(int)offsetNum withCompletionHandler:(void (^__nonnull)(NSMutableArray<ParkModel *> * __nullable parkArray, NSError * __nullable error)) completionHandler;

-(NSMutableArray<ParkModel *> *_Nullable)parseParkJSON: (NSData *_Nullable)data;

@end
