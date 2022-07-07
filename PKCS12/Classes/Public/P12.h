//
//  P12.h
//
//  Created by Xman on 2020/9/3.
//  Copyright © 2020 Xman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P12Validity : NSObject

///生效时间
@property (nonatomic, strong, readonly) NSDate *notBefore;
///过期时间
@property (nonatomic, strong, readonly) NSDate *notAfter;

@property (nonatomic, assign, readonly) BOOL isExpired;

+ (instancetype)validityWithNotBefore:(NSDate *)notBefore notAfter:(NSDate *)notAfter;

@end





@interface P12Organization : NSObject

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSString *unitName;

@property (nonatomic, strong, readonly) NSString *commonName;

@property (nonatomic, strong, readonly) NSString *countryName;

@end






@interface P12 : NSObject

/// 证书名称，同：subject.commonName
@property (nonatomic, strong, readonly) NSString *name;

/// 有效期
@property (nonatomic, strong, readonly) P12Validity *validity;

/// 颁发者：Apple
@property (nonatomic, strong, readonly) P12Organization *issuer;

/// 持有者：Developer
@property (nonatomic, strong, readonly) P12Organization *subject;

/// 序列号
@property (nonatomic, strong, readonly) NSString *serialNumber;

/// 版本号
@property (nonatomic, assign, readonly) long version;

/// SHA1
@property (nonatomic, strong, readonly) NSString *sha1;

/// 密码
@property (nonatomic, strong, readonly) NSString *password;

+ (instancetype)p12WithContentsOfFile:(NSString *)filePath password:(NSString *)password error:(NSError **)error;

@end
