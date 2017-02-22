//
//  NSDictionary+Resolve.m
//  MerchantClient
//
//  Created by huylens on 2/16/16.
//  Copyright © 2016 huylens. All rights reserved.
//

#import "NSDictionary+Resolve.h"
#import "NSString+Encrypt.h"
@implementation NSDictionary (Resolve)
- (BOOL)resultOK{
    
    return [self[@"rsp_code"] isEqualToString:@"succ"];
    
}
- (NSString *)errorMessage{
    return self[@"error_msg"];
}
- (NSDictionary *)signedWithSecureCode:(NSString *)code{
    if (code.length == 0){
        return  self;
    }
    NSArray *allKeys = [self allKeys];

    NSArray *sortedKeys =[allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    //拼接字符串
    NSMutableString *needMd5String = [NSMutableString string];
    for (NSInteger i =0; i<sortedKeys.count; i++) {
        NSString *formatStr = i == 0 ? @"%@=%@" : @"&%@=%@";
        [needMd5String appendFormat:formatStr,sortedKeys[i],self[sortedKeys[i]]];
    }
    [needMd5String appendString:code];
    NSString *signedString = [needMd5String md5];
    
    NSMutableDictionary *mutParametersDic = [NSMutableDictionary dictionaryWithDictionary:self];
    [mutParametersDic setObject:signedString forKey:@"sign"];
    
    return mutParametersDic;

}
- (NSString *)convertToString{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:nil] encoding:NSUTF8StringEncoding];
}
- (NSString *)getParamStr
{
    NSMutableString *str = [NSMutableString string];
    for (NSString *key in [self allKeys]){
        if ([self[key] isKindOfClass:[NSDictionary class]]){
            [str appendFormat:@"&%@=%@",key,[(NSDictionary *)self[key] convertToString]];
        }else{
        [str appendFormat:@"&%@=%@",key,self[key]];
        }
    }
    return [str substringFromIndex:1];
}
@end
