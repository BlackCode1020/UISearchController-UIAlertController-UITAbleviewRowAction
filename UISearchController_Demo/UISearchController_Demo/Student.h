//
//  Student.h
//  UISearchController_Demo
//
//  Created by 李大泽 on 14/10/17.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

#pragma mark - 声明属性
@property (nonatomic, copy) NSString *name;             // 姓名
@property (nonatomic, copy) NSString *phoneNumber;      // 电话号码
@property (nonatomic, copy) NSString *gender;           // 性别

#pragma mark - 声明方法
#pragma mark 初始化方法
- (instancetype)initWithName:(NSString *)name
                 phoneNumber:(NSString *)phoneNumber
                      gender:(NSString *)gender;

#pragma mark 便利构造器
+ (instancetype)studentWithName:(NSString *)name
                    phoneNumber:(NSString *)phoneNumber
                         gender:(NSString *)gender;



@end
