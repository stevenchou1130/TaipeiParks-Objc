//
//  ParkModel.m
//  TaipeiParks-Objc
//
//  Created by steven.chou on 2017/5/30.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

#import "ParkModel.h"

@implementation ParkModel

- (instancetype)initWithParkName:(NSString *)parkName name:(NSString *)name image:(NSString *)image introduction:(NSString *)introduction {

    _parkName = parkName;
    _name = name;
    _image = image;
    _introduction = introduction;

    return self;
}

@end
