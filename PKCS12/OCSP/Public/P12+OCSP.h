//
//  P12+OCSP.h
//  PKCS12
//
//  Created by 吴双 on 2022/7/11.
//

#import "P12.h"

@interface P12 (OCSP)

- (BOOL)syncCheckIsRevoked;

@end
