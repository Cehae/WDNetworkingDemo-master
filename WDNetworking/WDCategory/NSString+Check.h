//
//  NSObject+Check.h
//  MerchantClient
//
//  Created by huylens on 4/12/16.
//  Copyright © 2016 huylens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)
- (BOOL)validateMobileNum;
- (BOOL)validatePureNum;
- (BOOL)matchRegexp:(NSString *)regexp;
- (BOOL)validatePrice;
- (BOOL)validateNumAndDot;
@end

@interface NSString (buildTransactionNo)
+ (NSString *)buildTransactionNo;
@end