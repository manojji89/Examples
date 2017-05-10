//
//  main.m
//  keyChainSample
//
//  Created by Manoj Singhal on 5/10/17.
//  Copyright © 2017 manojsinghal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {

        KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"manoj.singhal1989@gmail.com" accessGroup:nil];
        [keychain setObject:@"manoj89" forKey:(__bridge NSString *)kSecAttrAccount];
        [keychain setObject:@"password" forKey:(__bridge NSString *)kSecValueData];
        [keychain setObject:@"email" forKey:(__bridge NSString *)kSecAttrService];

        NSString* username = [keychain objectForKey:(__bridge NSString *)kSecAttrAccount];
        NSString* password = [keychain objectForKey:(__bridge NSString *)kSecValueData];


        NSLog(@"User name %@",username);
        NSLog(@"Password %@",password);


        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
