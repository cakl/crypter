//
//  crypter.h
//  crypterOSX
//
//  Created by Sebastian Bock on 02.10.14.
//  Copyright (c) 2014 Apptivity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNDecryptor.h"
#import "RNEncryptor.h"
#import <AppKit/AppKit.h>

@interface ATCrypter : NSObject

+(void)encryptImagesInCurrentDirectoryWithPassword:(NSString*)password;
+(void)decryptImagesInCurrentDirectoryWithPassword:(NSString*)password;

@end
