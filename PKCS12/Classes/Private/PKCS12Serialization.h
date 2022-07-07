//
//  PKCS12Serialization.h
//
//  Created by Xman on 2020/9/3.
//  Copyright © 2020 Xman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class P12;

@interface PKCS12Serialization : NSObject

+ (P12 *)p12WithFile:(NSString *)path password:(NSString *)password error:(NSError **)error;

@end
