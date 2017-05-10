//
//  AppDelegate.h
//  keyChainSample
//
//  Created by Manoj Singhal on 5/10/17.
//  Copyright © 2017 manojsinghal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

