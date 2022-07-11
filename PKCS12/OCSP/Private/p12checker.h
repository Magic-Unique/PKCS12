//
//  p12checker.hpp
//  ECSignerForiOS
//
//  Created by Even on 2020/9/12.
//  Copyright © 2020 even_cheng. All rights reserved.
//
#include <openssl/x509.h>

@interface P12Checker : NSObject

+ (BOOL)isP12Revoked:(X509 *)x509 G3:(BOOL)isG3;

@end
