//
//  ChannelUnitModel.m
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//
#import <objc/runtime.h>
#import "ChannelUnitModel.h"

@implementation ChannelUnitModel
-(NSString *)description{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < count; ++i) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *proName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:proName];
        
        [str appendFormat:@"<%@ : %@> \n", proName, value];
    }
    free(ivars);
    return str;
}
@end
