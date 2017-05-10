//
//  main.m
//  polymorhsm
//
//  Created by Manoj Singhal on 5/10/17.
//  Copyright © 2017 GeminiSoltions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface Shape : NSObject
{
    CGFloat area;
}

-(void)printArea;
-(void)calculateArea;

@end

@implementation Shape

-(void)printArea{

}
-(void)calculateArea{

}

@end


@interface Square : Shape
{
    CGFloat length;
}

-(id)initWithLength:(CGFloat)lenght1;

@end


@implementation Square

-(id)initWithLength:(CGFloat)lenght1{
    length=lenght1;
    return self;
}

-(void)calculateArea{
    area=length*length;
}

-(void)printArea{
    NSLog(@"Area of square is %f",area);
}

@end


@interface Rectangle : Shape
{
    CGFloat length;
    CGFloat width;
}

-(id)initWithLength:(CGFloat)length1 withWidth:(CGFloat)width1;
@end

@implementation Rectangle
-(id)initWithLength:(CGFloat)length1 withWidth:(CGFloat)width1{
    length=length1;
    width=width1;
    return self;
}
-(void)calculateArea{
    area=length*width;
}

-(void)printArea{
    NSLog(@"Area of rectangle is %f",area);
}


@end




int main(int argc, char * argv[]) {
    @autoreleasepool {


        Shape *square=[[Square alloc]initWithLength:5.0];
        [square calculateArea];
        [square printArea];


        Shape *rectangle=[[Rectangle alloc]initWithLength:10.0 withWidth:10.0];
        [rectangle calculateArea];
        [rectangle printArea];


        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));

    }
}
