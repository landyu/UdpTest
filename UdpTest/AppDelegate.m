//
//  AppDelegate.m
//  UdpTest
//
//  Created by Landyu on 15/6/9.
//  Copyright (c) 2015年 Landyu. All rights reserved.
//

#import "AppDelegate.h"
#import "AsyncUdpSocket.h"


#define SERVER_IP    @"192.168.1.102"
#define SERVER_PORT  8080



@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize udpSocket = _udpSocket;




//发送短消息
-(void)sendString
{
    static int i = 0;
    
    NSString *messageStr = [NSString stringWithFormat: @"message = %d", i++];
    
    //开始发送
    BOOL res = [self.udpSocket sendData: [messageStr dataUsingEncoding: NSUTF8StringEncoding]
                                 toHost: SERVER_IP
                                   port: SERVER_PORT
                            withTimeout: -1
                                    tag: i++];
    
    if (!res)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
                                                        message: @"发送失败"
                                                       delegate: self
                                              cancelButtonTitle: @"取消"
                                              otherButtonTitles: nil];
        [alert show];
        //[alert release];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化udp
    self.udpSocket = [[AsyncUdpSocket alloc] initWithDelegate: self];
    
    NSError *error = nil;
    
    [self.udpSocket bindToPort: SERVER_PORT error: &error];
    [_udpSocket receiveWithTimeout: -1 tag: 0];
    
    float button_center_y = 20;
    float button_center_offset = 50;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] init];
    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    
    _sendButton=[[UIButton alloc]initWithFrame:CGRectMake(60, 60, 200, 60)];
    _sendButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _sendButton.frame = CGRectMake(0, 0, 200, 30);
    _sendButton.center = CGPointMake(320 / 2, button_center_y += button_center_offset);
    _sendButton.backgroundColor = [UIColor greenColor];
    [_sendButton addTarget: self action: @selector(sendString) forControlEvents: UIControlEventTouchUpInside];
    [_sendButton setTitle: @"Send String" forState: UIControlStateNormal];
    [self.viewController.view addSubview: _sendButton];
    //[self.window addSubview: _sendButton];
    //[self.window addSubview: self.viewController.view];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called when the socket has received the requested datagram.
 *
 * Due to the nature of UDP, you may occasionally receive undesired packets.
 * These may be rogue UDP packets from unknown hosts,
 * or they may be delayed packets arriving after retransmissions have already occurred.
 * It's important these packets are properly ignored, while not interfering with the flow of your implementation.
 * As an aid, this delegate method has a boolean return value.
 * If you ever need to ignore a received packet, simply return NO,
 * and AsyncUdpSocket will continue as if the packet never arrived.
 * That is, the original receive request will still be queued, and will still timeout as usual if a timeout was set.
 * For example, say you requested to receive data, and you set a timeout of 500 milliseconds, using a tag of 15.
 * If rogue data arrives after 250 milliseconds, this delegate method would be invoked, and you could simply return NO.
 * If the expected data then arrives within the next 250 milliseconds,
 * this delegate method will be invoked, with a tag of 15, just as if the rogue data never appeared.
 *
 * Under normal circumstances, you simply return YES from this method.
 **/
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString *s = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog(@"didReceiveData, host = %@, tag = %ld, s = %@", host, tag, s);
    
    return NO;
}
/**
 * Called if an error occurs while trying to receive a requested datagram.
 * This is generally due to a timeout, but could potentially be something else if some kind of OS error occurred.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called when the socket is closed.
 * A socket is only closed if you explicitly call one of the close methods.
 **/
- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

#pragma mark -

@end
