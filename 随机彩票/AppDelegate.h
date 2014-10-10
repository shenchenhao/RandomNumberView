//
//  AppDelegate.h
//  随机彩票
//
//  Created by 沈 晨豪 on 14-1-27.
//  Copyright (c) 2014年 sch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    RootController *_root_controller;
}

@property (nonatomic, retain) RootController *root_controller;
@property (strong, nonatomic) UIWindow       *window;

@end
