//
//  NSString+Encrypt.m
//  MerchantClient
//
//  Created by huylens on 2/17/16.
//  Copyright © 2016 huylens. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Encrypt)
- (NSString *)md5{
    const char *originString = [self UTF8String];
   
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(originString, (CC_LONG)strlen(originString), result);
    NSMutableString *hashedString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [hashedString appendFormat:@"%02X",result[i]];
    }
    return hashedString;
}
@end
