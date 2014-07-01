//
//  AppDelegate.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/24/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "AppDelegate.h"
#import "Defines.h"
#import "Utils.h"
@interface AppDelegate()
// xmpp
- (void) setupStream;
- (void) goOnline;
- (void) goOffline;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setup];
    if([[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_USERS_EMAIL] != nil){
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_USERS_EMAIL];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_USERS_PASSWORD];
    }
    _firstLaunch = YES;
     [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) setup
{
    _isLoggedIn = NO;
//    NSUserDefaults *defts = [NSUserDefaults standardUserDefaults];
//    if ([defts objectForKey:DEFAULTS_IS_LOGGED_IN]) {
//        _isLoggedIn = [defts boolForKey:DEFAULTS_IS_LOGGED_IN];
//    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _navController = [storyboard instantiateViewControllerWithIdentifier:@"InitVC"];
    _sideMenuVC = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuVC"];
    _patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientManagementVC"];
    _patientVC.title = @"Patients";
    
    _journalVC = [storyboard instantiateViewControllerWithIdentifier:@"JournalVC"];
    _journalVC.title = @"Journal";

    _loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    _loginVC.title = @"Login";
    _homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    _homeVC.title = @"Home";
    _messagesVC = [storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    _messagesVC.title = @"Message";
    _chatsListVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatsListVC"];
    _chatsListVC.title = @"Messages";
    _supportersVC = [storyboard instantiateViewControllerWithIdentifier:@"SupportersVC"];
    _supportersVC.title = @"Supporters";
    _profileVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
    _profileVC.title = @"Profile";
    _myReportsVC = [storyboard instantiateViewControllerWithIdentifier:@"ReportsVC"];
    _myReportsVC.title = @"My Reports";
    if (_isLoggedIn) {
        _navController.viewControllers = [NSArray arrayWithObject:_homeVC];
    } else {
        _navController.viewControllers = [NSArray arrayWithObject:_loginVC];
    }
    _container= [MFSideMenuContainerViewController
                 containerWithCenterViewController:_navController
                 leftMenuViewController:_sideMenuVC
                 rightMenuViewController:nil];
    self.window.rootViewController = _container;
    [self.window makeKeyAndVisible];

    if (!_isLoggedIn) {
        _loginVC.sideMenuButton.hidden = YES;
        _container.panMode = MFSideMenuPanModeNone;
    }

    if (!IS_IOS_7) {
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1],
          UITextAttributeTextColor,
          nil]];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    NSLog(@"My token is: %@", deviceToken);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([(NSString*)[defaults objectForKey:@"push_token"] length] > 0 ){
        NSLog(@"old push %@", [defaults objectForKey:@"push_token"]);
    }else{
        [defaults setValue:deviceToken forKey:DEFAULTS_PUSH_TOKEN];
        [defaults synchronize];
        NSLog(@"old push %@", deviceToken);
    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received notification: %@", userInfo);
}

//- (void) setIsLoggedIn:(BOOL)isLoggedIn
//{
//    _isLoggedIn = isLoggedIn;
//    if (isLoggedIn) {
//        _authToken = @"f9065d23ce2940532a6eea05149f6e4e";
//        _container.panMode = MFSideMenuPanModeCenterViewController | MFSideMenuPanModeSideMenu;
//    } else {
//        _container.panMode = MFSideMenuPanModeNone;
//    }
//}

#pragma XMPP

- (void) setupStream
{
    NSLog(@"Will set up stream");
    _stream = [[XMPPStream alloc] init];
    [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void) goOnline
{
    NSLog(@"Will go online");

    XMPPPresence *presence = [XMPPPresence presence];
    [_stream sendElement:presence];
}

- (void) goOffline
{
    NSLog(@"Will go offline");
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_stream sendElement:presence];
}


- (BOOL) connect
{
    NSLog(@"connecting..");
    [self setupStream];
    if(![_stream isDisconnected]){
        return YES;
    }
    _stream.myJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",_myJid]];
    _stream.hostName = @"beta.cancerlife.net";
    [_stream setHostPort:5222];
    NSError *error = nil;
    NSLog(@"trying to connect.");
    if(![_stream connectWithTimeout:10.0f error:&error]){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Can't connect to the server - %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

- (void) disconnect
{
    [self goOffline];
    [_stream disconnect];
}

- (void) xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error = nil;
    NSLog(@"Trying to go with %@ and %@",_userName,_password);
    XMPPReconnect* xmppReconnect = [[XMPPReconnect alloc] init];
    [xmppReconnect activate:_stream];
    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_stream authenticateWithPassword:_password error:&error];
}

- (void) xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationXMPPStreamDidFailToAuthenticate object:error];
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConnectionDidTimeout object:nil];
}

- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"XMPPStreamDidAuthenticate!");
    if(_firstLaunch){
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationXMPPStreamDidAuthenticate object:nil];
        [self goOnline];
    }
}

- (void) xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationXMPPPresenceReceived object:presence];
    NSString *presenceType = [presence type];
    NSString *myUsername = [[presence to] user];
    NSString *presenceFromUser = [[presence from] user];
//    if(![presenceFromUser isEqualToString:myUsername]){
//        if([presence attributeForName:@"type"] == nil) {
//            for (Player *aPlayer in _friends) {
//                if([presenceFromUser caseInsensitiveCompare:[aPlayer username]] == NSOrderedSame){
//                    aPlayer.online = YES;
//                }
//            }
//        } else if ([presenceType isEqualToString:@"unavailable"]){
//            for (Player *aPlayer in _friends) {
//                if([presenceFromUser caseInsensitiveCompare:[aPlayer username]] == NSOrderedSame){
//                    aPlayer.online = NO;
//                }
//            }
//        }
//    }
}

- (void) xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationXMPPMessageReceived object:message];
}

- (void) xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationXMPPMessageSent object:message];
}

@end
