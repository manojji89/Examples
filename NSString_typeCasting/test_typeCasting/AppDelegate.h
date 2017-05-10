//
//  AppDelegate.h
//  test_typeCasting
//
//  Created by Manoj Singhal on 5/5/17.
//  Copyright © 2017 GeminiSoltions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

