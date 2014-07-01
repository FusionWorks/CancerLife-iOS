//
//  AppDelegate.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/24/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "LoginVC.h"
#import "SideMenuVC.h"
#import "JournalVC.h"
#import "HomeVC.h"
#import "MessagesVC.h"
#import "InvitesVC.h"
#import "ProfileVC.h"
#import "SupportersVC.h"
#import "ReportsVC.h"
#import "ChatsListVC.h"
#import "PatientManagementVC.h"

#import "XMPPStream.h"
#import "XMPPJID.h"
#import "XMPPPresence.h"
#import "NSXMLElement+XMPP.h"
#import "XMPPMessage.h"
#import "XMPPRoster.h"
#import "XMPPReconnect.h"
#import "DDXMLElement.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic)         BOOL isLoggedIn;

// View Controllers Pointers

@property (strong, nonatomic) MFSideMenuContainerViewController *container;
// ^ children ^
@property (strong, nonatomic) UINavigationController            *navController;
@property (strong, nonatomic) HomeVC                            *homeVC;
@property (strong, nonatomic) SideMenuVC                        *sideMenuVC;
@property (strong, nonatomic) JournalVC                         *journalVC;
@property (strong, nonatomic) PatientManagementVC               *patientVC;
@property (strong, nonatomic) LoginVC                           *loginVC;
@property (strong, nonatomic) MessagesVC                        *messagesVC;
@property (strong, nonatomic) SupportersVC                      *supportersVC;
@property (strong, nonatomic) ChatsListVC                       *chatsListVC;
@property (strong, nonatomic) ProfileVC                         *profileVC;
@property (strong, nonatomic) ReportsVC                         *myReportsVC;

// session info

@property (strong, nonatomic) NSString                          *authToken;
@property (strong, nonatomic) NSString                          *firstName;
@property (strong, nonatomic) NSString                          *lastName;
@property (strong, nonatomic) NSNumber                          *userID;
@property (strong, nonatomic) NSNumber                          *gender;
@property (strong, nonatomic) NSNumber                          *organizationID;
@property (strong, nonatomic) NSString                          *role;
@property (strong, nonatomic) NSString                          *cellPhone;
@property (strong, nonatomic) NSString                          *homePhone;
@property (strong, nonatomic) NSString                          *country;
@property (strong, nonatomic) NSDate                            *dateOfBirth;
@property (strong, nonatomic) NSString                          *state;
@property (strong, nonatomic) NSString                          *street;
@property (strong, nonatomic) NSString                          *city;
@property (strong, nonatomic) NSString                          *language;
@property (strong, nonatomic) NSString                          *timezone;
@property (strong, nonatomic) UIImage                           *publicImage;
@property (strong, nonatomic) UIImage                           *privateImage;
@property (strong, nonatomic) NSString                          *myJid;


@property (strong, nonatomic) NSString                          *userName;
@property (strong, nonatomic) NSString                          *password;

@property (readonly, nonatomic) XMPPStream                      *stream;
@property (nonatomic, strong) XMPPRoster                        *roster;
@property (nonatomic) BOOL firstLaunch;

- (BOOL) connect;
- (void) disconnect;

@end