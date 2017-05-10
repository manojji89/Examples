//
//  main.m
//  DataEncapsulation
//
//  Created by Manoj Singhal on 5/10/17.
//  Copyright © 2017 GeminiSoltions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@interface Adder : NSObject{
    NSInteger total;

}


-(id)initWithInitialNumber:(NSInteger)initialNumber;
-(void)addNumberSum:(NSInteger)number;
-(NSInteger)getTotal;

@end


@implementation Adder
-(id)initWithInitialNumber:(NSInteger)initialNumber{

    total=initialNumber;
    return self;

}
-(void)addNumberSum:(NSInteger)number{
    total=total+number;

}
-(NSInteger)getTotal{
    return total;
}


@end




int main(int argc, char * argv[]) {
    @autoreleasepool {
        Adder *adder=[[Adder alloc]initWithInitialNumber:5.0];
        [adder addNumberSum:5];
        [adder addNumberSum:10];
        NSLog(@"totl number is %ld ",(long)[adder getTotal]);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
