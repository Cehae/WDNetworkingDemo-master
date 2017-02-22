//
//  NSDictionary+Resolve.h
//  MerchantClient
//
//  Created by huylens on 2/16/16.
//  Copyright © 2016 huylens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Resolve)
- (BOOL)resultOK;
- (NSString *)errorMessage;
- (NSDictionary *)signedWithSecureCode:(NSString *)code;
- (NSString *)convertToString;
- (NSString *)getParamStr;
@end
