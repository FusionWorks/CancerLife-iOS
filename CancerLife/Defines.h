//
//  Defines.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#ifndef CancerLife_Defines_h
#define CancerLife_Defines_h

//----------------- REST
#define MALE                                            1
#define FEMALE                                          !MALE

//----------------- MOODS
#define GOOD_IMAGE_NAME                                 20
#define OPTIMISTIC_IMAGE_NAME                           21
#define ANNOYED_IMAGE_NAME                              24
#define DOWN_IMAGE_NAME                                 27
#define NERVOUS_IMAGE_NAME                              29


//----------------- DEFAULTS

#define DEFAULTS_IS_LOGGED_IN                           @"USER_DEFAULTS_IS_LOGGED_IN"
#define DEFAULTS_USERS_EMAIL                            @"USER_DEFAULTS_USERS_EMAIL"
#define DEFAULTS_USERS_PASSWORD                         @"USER_DEFAULTS_USERS_PASSWORD"
#define DEFAULTS_PUSH_TOKEN                             @"USER_DEFAULTS_PUSH_TOKEN"
//----------------- API ENDPOINTS

#define API_MAIN                                        @"https://beta.cancerlife.net/"
#define API_LOGIN_ENDPOINT                              @"https://beta.cancerlife.net/rest/login/"
#define API_REGISTER_FIELDS_ENDPOINT                    @"https://beta.cancerlife.net/rest/get_register_fields/"
#define API_REGISTER_ENDPOINT                           @"https://beta.cancerlife.net/rest/register/"
#define API_CAREGIVER_REGISTER_ENDPOINT                                                       @"https://beta.cancerlife.net/rest/caregiver_register"
#define API_GET_CHATS                                   @"https://beta.cancerlife.net/rest/get_chats/"
#define API_GET_COMMENTS                                @"https://beta.cancerlife.net/rest/get_journal_comments/"
#define API_POST_JOURNAL                                @"https://beta.cancerlife.net/rest/journal/"
#define API_GET_JOURNAL                                 @"https://beta.cancerlife.net/rest/view_journal/"
#define API_POST_JOURNAL_COMMENT                        @"https://beta.cancerlife.net/rest/new_journal_comment/"
#define API_GET_JOURNAL_FIELDS                          @"https://beta.cancerlife.net/rest/get_journal_fields/"
#define API_POST_SUPPORTERS                             @"https://beta.cancerlife.net/rest/new_supporters/"
#define API_GET_PROFILE                                 @"https://beta.cancerlife.net/rest/view_profile/"
#define API_GET_MESSAGES                                @"https://beta.cancerlife.net/rest/get_messages/"
#define API_GET_PATIENTS                                @"https://beta.cancerlife.net/rest/patients/"
#define API_POST_PHOTO                                  @"https://beta.cancerlife.net/rest/photo/"
#define API_POST_PROFILE                                @"https://beta.cancerlife.net/rest/profile/"
#define API_GET_REPORTS                                 @"https://beta.cancerlife.net/rest/reports/"
#define API_GET_SUPPORTERS                              @"https://beta.cancerlife.net/rest/view_supporters/"
#define API_GET_SEARCH                                  @"https://beta.cancerlife.net/rest/patients?search="
//----------------- NOTIFICATIONS
#define PUBLIC_PHOTO_UPDATED_NOTIFICATION               @"PUBLIC_PHOTO_UPDATED"

#define kNotificationXMPPStreamDidAuthenticate          @"NOTIFICATION_XMPP_STREAM_DID_AUTHENTICATE"
#define kNotificationXMPPStreamDidFailToAuthenticate    @"NOTIFICATION_XMPP_STREAM_DID_FAIL_TO_AUTHENTICATE"
#define kNotificationConnectionDidTimeout               @"NOTIFICATION_XMPP_STREAM_CONNECTION_DID_TIMEOUT"
#define kNotificationXMPPMessageReceived                @"NOTIFICATION_XMPP_MESSAGE_RECEIVED"
#define kNotificationXMPPPresenceReceived               @"NOTIFICATION_XMPP_PRESENCE_RECEIVED"
#define kNotificationXMPPMessageSent                    @"NOTIFICATION_XMPP_MESSAGE_SEND"

#define kNotificationUserLost                           @"NOTIFICATION_GAME_USER_LOST"
#define kNotificationAcceptedFriendRequest              @"NOTIFICATION_ACCEPTED_FRIEND_REQUEST"

#endif