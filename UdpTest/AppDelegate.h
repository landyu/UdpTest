//
//  AppDelegate.h
//  UdpTest
//
//  Created by Landyu on 15/6/9.
//  Copyright (c) 2015年 Landyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AsyncUdpSocket             *_udpSocket;
    
    UIButton *_sendButton;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic, retain) AsyncUdpSocket *udpSocket;



@end

