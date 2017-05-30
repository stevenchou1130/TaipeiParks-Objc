//
//  ParkModel.h
//  TaipeiParks-Objc
//
//  Created by steven.chou on 2017/5/30.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkModel : NSObject

@property (strong, nonatomic, readonly) NSString *parkName;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *image;
@property (strong, nonatomic, readonly) NSString *introduction;

- (instancetype)initWithParkName:(NSString *)parkName name:(NSString *)name image:(NSString *)image introduction:(NSString *)introduction;

@end
