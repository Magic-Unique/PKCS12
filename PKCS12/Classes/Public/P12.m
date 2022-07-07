//
//  P12.m
//
//  Created by Xman on 2020/9/3.
//  Copyright © 2020 Xman. All rights reserved.
//

#import "P12.h"
#import "PKCS12Serialization.h"
#import "P12+Private.h"

@implementation P12Validity

+ (instancetype)validityWithNotBefore:(NSDate *)notBefore notAfter:(NSDate *)notAfter {
    if (!notBefore || !notAfter) {
        return nil;
    }
    P12Validity *validity = [[self alloc] init];
    validity.notBefore = notBefore;
    validity.notAfter = notAfter;
    return validity;
}

- (BOOL)isExpired {
    BOOL afterNotBefore = self.notBefore.timeIntervalSinceNow < 0;
    BOOL beforeNotAfter = self.notAfter.timeIntervalSinceNow > 0;
    return !(afterNotBefore && beforeNotAfter);
}

@end



@implementation P12Organization @end


@implementation P12

+ (instancetype)p12WithContentsOfFile:(NSString *)filePath password:(NSString *)password error:(NSError *__autoreleasing *)error {
    return [PKCS12Serialization p12WithFile:filePath password:password error:error];
}

- (NSString *)name {
    return self.subject.commonName;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<P12: '%@' (%@)>", self.name, self.validity.isExpired ? @"valid" : @"expired"];
}

@end
