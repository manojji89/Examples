//
//  ViewController.m
//  test_typeCasting
//
//  Created by Manoj Singhal on 5/5/17.
//  Copyright © 2017 GeminiSoltions. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSString *str1=[NSString stringWithFormat:@"hello1"];
    NSString *str2=[NSString stringWithFormat:@"hello1"];
    NSString *str3 = [[NSString alloc] initWithString:@"hello1"];


// == compares the pointer but in our example we are taking same string value to different object  using @  so it will point to same address so output will be TRUE condition
    if (str1==str2) {
        NSLog(@"Both String are equal");
    }
    else{
        NSLog(@"Both String not are equal");
    }


    // == compares the pointer but in our example we are taking same string value to different object but we have allocated different string so both object will pount to different address so output will be FALSE condition
    if (str1==str3) {

        NSLog(@"Both String are equal");
    }
    else{
        NSLog(@"Both String not are equal");

    }


  // compare:= compares the values of objects so output will be TRUE condition
    if ([str1 compare:str3]== NSOrderedSame) {
        NSLog(@"Both String are equal");

    }
    else{
        NSLog(@"Both String not are equal");

    }


    // isEqual compares the values of objects so output will be TRUE condition

    if ([str1 isEqual:str2]) {

        NSLog(@"Both String are equal");
    }
    else{
        NSLog(@"Both String not are equal");
        
    }

    // isEqual compares the values of objects so output will be TRUE condition

    if ([str1 isEqual:str3]) {

        NSLog(@"Both String are equal");
    }
    else{
        NSLog(@"Both String not are equal");

    }


    // isEqualToString compares the values of objects so output will be TRUE condition
    if ([str1 isEqualToString:str2]) {

        NSLog(@"Both String are equal");
    }
    else{
        NSLog(@"Both String not are equal");

    }


    // isEqualToString compares the values of objects so output will be TRUE condition
    if ([str1 isEqualToString:str3]) {

        NSLog(@"Both String are equal");
    }
    else{
        NSLog(@"Both String not are equal");
        
    }

    // == compares the pointers since we have initialized the same value to first object so the pointer be be same for same value so output will be TRUE condition
    if (str1==@"hello1") {

        NSLog(@"Both String are equal");
    }
    else{
        NSLog(@"Both String not are equal");
        
    }








    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
