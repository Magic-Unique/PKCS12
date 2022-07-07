//
//  P12+Private.h
//  PKCS12
//
//  Created by 吴双 on 2022/6/17.
//

#import "P12.h"

@interface P12Validity ()
@property (nonatomic, strong) NSDate *notBefore;
@property (nonatomic, strong) NSDate *notAfter;
@end

@interface P12Organization ()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *unitName;
@property (nonatomic, strong) NSString *commonName;
@property (nonatomic, strong) NSString *countryName;
@end


@interface P12 ()


@property (nonatomic, strong) P12Validity *validity;

@property (nonatomic, strong) P12Organization *issuer;
@property (nonatomic, strong) P12Organization *subject;

@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, assign) long version;
@property (nonatomic, strong) NSString *sha1;

@property (nonatomic, strong) NSString *password;

@end
