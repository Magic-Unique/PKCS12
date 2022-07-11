//
//  P12+OCSP.m
//  PKCS12
//
//  Created by 吴双 on 2022/7/11.
//

#import "P12+OCSP.h"
#import "p12checker.h"
#import "P12+Private.h"

@implementation P12 (OCSP)

- (BOOL)syncCheckIsRevoked {
    NSString *issuerOU = self.issuer.unitName;
    BOOL G3 = issuerOU && [issuerOU isEqualToString:@"G3"];
    return [P12Checker isP12Revoked:self.x509Cert G3:G3];
}

@end
