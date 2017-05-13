//
//  main.m
//  CheckPalindrom
//
//  Created by Manoj Singhal on 5/13/17.
//  Copyright © 2017 manojsinghal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"




@interface PalindromClass : NSObject
+(BOOL)checkPalindromeNumber:(int)number;

@end

@implementation PalindromClass
+(BOOL)checkPalindromeNumber:(int)number{
    int originalNumber,reversedNumber = 0,remainder;
    originalNumber=number;
    while (number!=0) {
        remainder=number%10;
        reversedNumber=(reversedNumber*10)+remainder;
        number=number/10;
    }

    if (reversedNumber==originalNumber) {
        NSLog(@"%d is Palindrome Number",originalNumber);

        return YES;
    }
    else{
        NSLog(@"%d is Not Palindrome Number",originalNumber);
        return NO;

    }
}



@end


// Palindrom numbers are the numbers which are similar when written in reversed order.
// eg  16461 , 44 ,101,  1001
// Approcah get the last remainder by dividing 10 and add it * 10

int main(int argc, char * argv[]) {
    @autoreleasepool {

        [PalindromClass checkPalindromeNumber:101];
        [PalindromClass checkPalindromeNumber:100];
        [PalindromClass checkPalindromeNumber:100100];
        [PalindromClass checkPalindromeNumber:16461];



        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
