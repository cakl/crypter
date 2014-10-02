//
//  crypter.m
//  crypterOSX
//
//  Created by Sebastian Bock on 02.10.14.
//  Copyright (c) 2014 Apptivity. All rights reserved.
//

#import "ATCrypter.h"

@implementation ATCrypter

+(void)encryptImagesInCurrentDirectoryWithPassword:(NSString*)password {
    NSLog(@"Start encrypting images");
    
    NSError *error;
    NSString* currentpath = [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentpath error:&error];
    
    if(error){ NSLog(@"Error reading current directory"); return; }
    
    NSIndexSet* indexes = [files indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString* fileName = obj;
        BOOL returnValue = NO;
        CFStringRef fileExtension = (CFStringRef) CFBridgingRetain([fileName pathExtension]);
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        if (UTTypeConformsTo(fileUTI, kUTTypeImage)) {
            NSLog(@"Image detected: %@", fileName);
            returnValue = YES;
        };
        CFRelease(fileUTI);
        return returnValue;
    }];
    
    
    NSArray* imageFiles = [files objectsAtIndexes:indexes];
    
    [imageFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* fileName = obj;
        NSString* absolutePath = [NSString stringWithFormat:@"%@/%@", currentpath, fileName];
        NSImage *imageToEncrypt = [[NSImage alloc] initWithContentsOfFile:absolutePath];
        NSBitmapImageRep *imgRep = [[imageToEncrypt representations] objectAtIndex: 0];
        NSData *data = [imgRep representationUsingType: NSJPEGFileType properties: nil];
        NSError* error;
        NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:password error:&error];
        NSString* exportFolder = [currentpath stringByAppendingPathComponent:@"encrypted"];
        
        NSString *exportPath = [NSString stringWithFormat:@"%@/%@", exportFolder, fileName];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:exportFolder withIntermediateDirectories:NO attributes:nil error:&error];
        
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:exportPath contents:encryptedData attributes:nil];
        if(!success) NSLog(@"Error writing encrypted image %@", fileName);
        
    }];
    
}

+(void)decryptImagesInCurrentDirectoryWithPassword:(NSString*)password {
    NSLog(@"Start decrypting images");
    
    NSError *error;
    NSString* currentpath = [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentpath error:&error];
    
    if(error){ NSLog(@"Error reading current directory"); return; }
    
    NSIndexSet* indexes = [files indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString* fileName = obj;
        BOOL returnValue = NO;
        CFStringRef fileExtension = (CFStringRef) CFBridgingRetain([fileName pathExtension]);
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        if (UTTypeConformsTo(fileUTI, kUTTypeImage)) {
            NSLog(@"Image detected: %@", fileName);
            returnValue = YES;
        };
        CFRelease(fileUTI);
        return returnValue;
    }];
    
    
    NSArray* imageFiles = [files objectsAtIndexes:indexes];
    
    [imageFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* fileName = obj;
        NSString* absolutePath = [NSString stringWithFormat:@"%@/%@", currentpath, fileName];
        NSData *data = [NSData dataWithContentsOfFile:absolutePath];
        NSError* error;
        NSData *encryptedData = [RNDecryptor decryptData:data withPassword:password error:&error];
        NSString* exportFolder = [currentpath stringByAppendingPathComponent:@"decrypted"];
        
        NSString *exportPath = [NSString stringWithFormat:@"%@/%@", exportFolder, fileName];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:exportFolder withIntermediateDirectories:NO attributes:nil error:&error];
        
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:exportPath contents:encryptedData attributes:nil];
        if(!success) NSLog(@"Error writing encrypted image %@", fileName);
        
    }];
    
}



@end
