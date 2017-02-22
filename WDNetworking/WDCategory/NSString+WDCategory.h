//
//  NSString+WDCategory.h
//  WDNetworkingDemo
//
//  Created by huylens on 17/1/9.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WDCategory)
/**
 解析url中的参数
 
 @return 参数字典
 */
- (NSMutableDictionary *)getURLParameters;

/**
 中文转义
 
 @return 转义后的字符串
 */
- (NSString *)URLEncoded;
@end
