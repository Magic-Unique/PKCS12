//
//  PKCS12Serialization.m
//
//  Created by Xman on 2020/9/3.
//  Copyright © 2020 Xman. All rights reserved.
//

#import "PKCS12Serialization.h"
#import <openssl/pkcs12.h>
#import <openssl/err.h>
#import <openssl/pem.h>
#import <CommonCrypto/CommonDigest.h>
#import "P12.h"
#import "P12+Private.h"

@interface PKCS12Serialization ()

@property (nonatomic, strong) P12 *info;

@property (nonatomic, strong) NSError *error;

@end

@implementation PKCS12Serialization

+ (P12 *)p12WithFile:(NSString *)path password:(NSString *)password error:(NSError *__autoreleasing *)error {
    PKCS12Serialization *serialization = [[self alloc] init];
    [serialization read:path password:password];
    if (serialization.error) {
        if (error) *error = serialization.error;
        return nil;
    }
    return serialization.info;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _info = [[P12 alloc] init];
    }
    return self;
}

- (void)read:(NSString *)filePath password:(NSString *)password {
    if (!filePath) {
        return ;
    }
    PKCS12 *p12 = NULL;
    X509* usrCert = NULL;
    EVP_PKEY* pkey = NULL;
    STACK_OF(X509)* ca = NULL;
    BIO*bio = NULL;
    OpenSSL_add_all_algorithms();
    ERR_load_crypto_strings();
    
    bio = BIO_new_file([filePath UTF8String], "r");
    //P12
    p12 = d2i_PKCS12_bio(bio, NULL); //得到p12结构
    PKCS12_parse(p12, [password UTF8String], &pkey, &usrCert, &ca); //得到x509结构
    
    if (!usrCert) {
        return ;
    }
    
    self.info.serialNumber = [self __getSerialNumberString:usrCert];
    
    NSDate *notBefore = [self __getNotBefore:usrCert];
    NSDate *notAfter = [self __getNotAfter:usrCert];
    self.info.validity = [P12Validity validityWithNotBefore:notBefore notAfter:notAfter];
    self.info.issuer = [self __getIssuserInfo:usrCert];
    self.info.subject = [self __getSubjectInfo:usrCert];
    self.info.sha1 = [self sha1:usrCert];
    self.info.version = [self __getVersion:usrCert];
    self.info.password = password;
    self.info.x509Cert = usrCert;
    
    PKCS12_free(p12);
    BIO_free_all(bio);
    EVP_PKEY_free(pkey);
}

- (NSString*)sha1:(X509 *)cert {
    PKCS12_SAFEBAG *safeBag = PKCS12_x5092certbag(cert);
    NSData *certData = [NSData dataWithBytes: safeBag->value.bag->value.x509cert->data   length:safeBag->value.bag->value.x509cert->length];
    unsigned char sha1Buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(certData.bytes, (unsigned int)certData.length, sha1Buffer);
    NSMutableString *fingerprint = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i){
        [fingerprint appendFormat:@"%02x ",sha1Buffer[i]];
    }
    NSString *fingerString = [fingerprint stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    fingerString = [fingerString stringByReplacingOccurrencesOfString:@" " withString:@""];
    PKCS12_SAFEBAG_free(safeBag);
    return fingerString.uppercaseString;
}

- (long)__getVersion:(X509 *)cert {
    long version = X509_get_version(cert);
    return version;
}

///序列号
- (NSString *)__getSerialNumberString:(X509*)usrCert {
    ASN1_INTEGER *serial = X509_get_serialNumber(usrCert);
    BIGNUM *bignum = ASN1_INTEGER_to_BN(serial, NULL);
    char *res = BN_bn2hex(bignum);
    NSString *serialStr = [NSString stringWithUTF8String:res];
    return serialStr;
}

- (P12Organization *)__getX509NameInfo:(X509_NAME *)name {
    P12Organization *organization = [[P12Organization alloc] init];
    
    X509_NAME_ENTRY *name_entry;
    long Nid;
    unsigned char msginfo[1024];
    const int entriesNum = X509_NAME_entry_count(name);
    for (int i = 0; i < entriesNum; i++) {
        name_entry = X509_NAME_get_entry(name, i);
        Nid = OBJ_obj2nid(X509_NAME_ENTRY_get_object(name_entry));
        ASN1_STRING *data =  X509_NAME_ENTRY_get_data(name_entry);
        memcpy(msginfo, data->data, data->length);
        msginfo[data->length]='\0';
        NSString *entryValue = [NSString stringWithUTF8String:(const char *)msginfo];
        switch(Nid) {
            case NID_countryName:
                organization.countryName = entryValue;
                break;
            case NID_organizationName:
                organization.name = entryValue;
                break;
            case NID_organizationalUnitName:
                organization.unitName = entryValue;
                break;
            case NID_commonName:
                organization.commonName = entryValue;
                break;
            case NID_userId:
                break;
            default:
                break;
        }
    }
    return organization;
}

///颁发机构
- (P12Organization *)__getIssuserInfo:(X509 *)usrCert {
    X509_NAME *issuer = X509_get_issuer_name(usrCert);
    if (!issuer) {
        return nil;
    }
    return [self __getX509NameInfo:issuer];
}

/////获取证书主题信息
- (P12Organization *)__getSubjectInfo:(X509 *)cert {
    X509_NAME *subject = X509_get_subject_name(cert);
    if (!subject) {
        return nil;
    }
    return [self __getX509NameInfo:subject];
}

- (NSDate *)__getNotBefore:(X509 *)cert {
    ASN1_TIME *start = NULL;
    time_t ttStart = {0};
    // 颁发时间
    start = X509_get_notBefore(cert);
    ttStart = [self __skf_ext_ASN1_GetTimeT:start];
    // 格林威治时间与北京时间相差八小时，所以加八小时。
    ttStart = ttStart + 8 * 60 * 60;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:ttStart];
    return startDate;
}

///有效时间
- (NSDate *)__getNotAfter:(X509 *)cert {
    ASN1_TIME *end = NULL;
    time_t ttEnd = {0};
    
    // 过期时间
    end = X509_get_notAfter(cert);
    ttEnd = [self __skf_ext_ASN1_GetTimeT:end];
    ttEnd = ttEnd + 8 * 60 * 60;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:ttEnd];
    return endDate;
}

///格林威治时间转本地时间
- (time_t)__skf_ext_ASN1_GetTimeT:(ASN1_TIME *)time {
    struct tm t;
    const char* str = (const char*) time->data;
    size_t i = 0;
    
    memset(&t, 0, sizeof(t));
    
    if (time->type == V_ASN1_UTCTIME) {/* two digit year */
        t.tm_year = (str[i++] - '0') * 10;
        t.tm_year += (str[i++] - '0');
        if (t.tm_year < 70)
            t.tm_year += 100;
    } else if (time->type == V_ASN1_GENERALIZEDTIME) {/* four digit year */
        t.tm_year = (str[i++] - '0') * 1000;
        t.tm_year+= (str[i++] - '0') * 100;
        t.tm_year+= (str[i++] - '0') * 10;
        t.tm_year+= (str[i++] - '0');
        t.tm_year -= 1900;
    }
    t.tm_mon  = (str[i++] - '0') * 10;
    t.tm_mon += (str[i++] - '0') - 1; // -1 since January is 0 not 1.
    t.tm_mday = (str[i++] - '0') * 10;
    t.tm_mday+= (str[i++] - '0');
    t.tm_hour = (str[i++] - '0') * 10;
    t.tm_hour+= (str[i++] - '0');
    t.tm_min  = (str[i++] - '0') * 10;
    t.tm_min += (str[i++] - '0');
    t.tm_sec  = (str[i++] - '0') * 10;
    t.tm_sec += (str[i++] - '0');
    
    /* Note: we did not adjust the time based on time zone information */
    return mktime(&t);
}

@end
