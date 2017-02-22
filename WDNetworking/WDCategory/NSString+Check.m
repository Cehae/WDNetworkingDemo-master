//
//  NSObject+Check.m
//  MerchantClient
//
//  Created by huylens on 4/12/16.
//  Copyright © 2016 huylens. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)
- (BOOL)validateMobileNum{
    NSString* number=@"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:self];
}
- (BOOL)validatePureNum{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:self];
}
- (BOOL)matchRegexp:(NSString *)regexp{
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexp];
    return [numberPre evaluateWithObject:self];
}
- (BOOL)validatePrice{
    return [self matchRegexp:@"^(0|[1-9][0-9]{0,9})(.[0-9]{1,2})?$"];
}
- (BOOL)validateNumAndDot{
    return [self matchRegexp:@"^[0-9.]*$"];
}
@end
@implementation NSString (buildTransactionNo)

+ (NSString *)buildTransactionNo{
    NSDateFormatter *printFormatter = [[NSDateFormatter alloc] init];
    printFormatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *printDate = [printFormatter stringFromDate:[NSDate date]];
    NSString *random = [NSString stringWithFormat:@"%05d",arc4random_uniform(100000)];
    return [NSString stringWithFormat:@"%@%@",printDate,random];
}

@end
