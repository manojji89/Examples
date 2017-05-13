//
//  main.m
//  CheckAnagram
//
//  Created by Manoj Singhal on 5/13/17.
//  Copyright © 2017 manojsinghal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
# define NO_OF_CHARS 256




@interface AnagramClass : NSObject


+(BOOL)checkAnagramString:(NSString*)string1 WithAnotherString:(NSString*)string2;

@end


@implementation AnagramClass

+(BOOL)checkAnagramString:(NSString*)string1 WithAnotherString:(NSString*)string2{
    NSCountedSet *countSet1=[[NSCountedSet alloc]init];
    NSCountedSet *countSet2=[[NSCountedSet alloc]init];

    if (string1.length!=string2.length) {
        NSLog(@"NOT ANAGRAM String");
        return NO;
    }


    for (int i=0; i<string1.length; i++) {
        [countSet1 addObject:@([string1 characterAtIndex:i])];
        [countSet2 addObject:@([string2 characterAtIndex:i])];
    }

    if ([countSet1 isEqual:countSet2]) {
        NSLog(@"ANAGRAM String");
        return YES;
    }
    else{
        NSLog(@"NOT ANAGRAM String");
        return NO;

    }

}


@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //areAnagram(@"manoj", @"janom");
        [AnagramClass checkAnagramString:@"manoj" WithAnotherString:@"janom"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}



//(BOOL)areAnagram(char *str1, char *str2)
//{
//    // Create a count array and initialize all values as 0
//    int count[NO_OF_CHARS] = {0};
//    int i;
//
//    // For each character in input strings, increment count in
//    // the corresponding count array
//    for (i = 0; str1[i] && str2[i];  i++)
//    {
//        count[str1[i]]++;
//        count[str2[i]]--;
//    }
//
//    // If both strings are of different length. Removing this condition
//    // will make the program fail for strings like "aaca" and "aca"
//    if (str1[i] || str2[i])
//        return false;
//
//    // See if there is any non-zero value in count array
//    for (i = 0; i < NO_OF_CHARS; i++)
//        if (count[i])
//            return false;
//    return true;
//}
