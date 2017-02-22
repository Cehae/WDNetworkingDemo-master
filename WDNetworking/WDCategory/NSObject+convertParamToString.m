//
//  NSObject+convertParamToString.m
//  WDNetworkingDemo
//
//  Created by huylens on 17/1/9.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "NSObject+convertParamToString.h"

@implementation NSObject (convertParamToString)

/**
 将字典/数组等转换成json字符串,用于请求时传递参数
 
 @return json字符串
 */
- (NSString *)convertedToString
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:nil] encoding:NSUTF8StringEncoding];
}
@end
