# PKCS12

[![CI Status](https://img.shields.io/travis/Magic-Unique/PKCS12.svg?style=flat)](https://travis-ci.org/Magic-Unique/PKCS12)
[![Version](https://img.shields.io/cocoapods/v/PKCS12.svg?style=flat)](https://cocoapods.org/pods/PKCS12)
[![License](https://img.shields.io/cocoapods/l/PKCS12.svg?style=flat)](https://cocoapods.org/pods/PKCS12)
[![Platform](https://img.shields.io/cocoapods/p/PKCS12.svg?style=flat)](https://cocoapods.org/pods/PKCS12)

[中文](./README.cn.md)

## 引入

PKCS12 支持 [CocoaPods](https://cocoapods.org). 修改 Podfile:

```ruby
pod 'PKCS12'
```

## 使用

```objc
#import <PKCS12/PKCS12.h>

NSError *error = nil;

// Parse file
P12 *cert = [P12 p12WithContentsOfFile:@"file.p12" password:@"1" error:&error];
NSLog(@"%@", cert.name);

// Check Revocation Status
dispatch_async_queue(globalQueue, ^{
    BOOL isRevoked = [cert syncCheckIsRevoked]; // Power by: even-cheng/p12Checker
});


```

## 作者

Magic-Unique, 516563564@qq.com

## License

PKCS12 is available under the MIT license. See the LICENSE file for more info.
