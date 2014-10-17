//
//  Student.m
//  UISearchController_Demo
//
//  Created by 李大泽 on 14/10/17.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "Student.h"

@implementation Student


#pragma mark - 实现方法
#pragma mark 初始化方法
- (instancetype)initWithName:(NSString *)name
                 phoneNumber:(NSString *)phoneNumber
                      gender:(NSString *)gender
{
    if (self = [super init]) {
        self.name = name;
        self.phoneNumber = phoneNumber;
        self.gender = gender;
    }
    return self;
}

#pragma mark 便利构造器
+ (instancetype)studentWithName:(NSString *)name
                    phoneNumber:(NSString *)phoneNumber
                         gender:(NSString *)gender
{
    return [[Student alloc] initWithName:name phoneNumber:phoneNumber gender:gender];
}

@end
