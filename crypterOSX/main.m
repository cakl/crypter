//
//  main.m
//  crypterOSX
//
//  Created by Sebastian Bock on 02.10.14.
//  Copyright (c) 2014 Apptivity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATCrypter.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        
        NSString* password = nil;
        
        if([args stringForKey:@"password"]){
            password = [args stringForKey:@"password"];
        } else if ([args stringForKey:@"p"]){
            password = [args stringForKey:@"p"];
        } else {
            NSLog(@"Error: no password argument provided. use -p or -password");
            return -1;
        }
        
        if([[args stringForKey:@"mode"] isEqualToString:@"encrypt"]) {
            [ATCrypter encryptImagesInCurrentDirectoryWithPassword:password];
            return 0;
        } else if([[args stringForKey:@"mode"] isEqualToString:@"decrypt"]){
            [ATCrypter decryptImagesInCurrentDirectoryWithPassword:password];
            return 0;
        } else {
            NSLog(@"Error: no mode provided. use -mode");
            return -1;
        }
        
    }
    return 0;
}


