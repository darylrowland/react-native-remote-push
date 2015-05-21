#import "RCTRemotePushManager.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@implementation RCTRemotePushManager

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

NSDictionary *startupNotification;

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    // Registered for remote notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeredForRemoteNotifications:) name:@"registeredForRemoteNotifications" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeredForRemoteNotifications:) name:@"registeredForRemoteNotificationsError" object:nil];
    
    // Received remote notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRemoteNotification:) name:@"receivedRemoteNotification" object:nil];
    
    // Received remote notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRemoteNotificationOnStart:) name:@"receivedRemoteNotificationOnStart" object:nil];
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

RCT_EXPORT_METHOD(requestPermissions)
{
    
    //Register for remote notifications straightaway
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // Now register for user notifications
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    
}

- (void) registeredForRemoteNotifications:(NSNotification *) notification {    
    NSDictionary *userInfo = notification.userInfo;
    NSData *deviceToken = [userInfo objectForKey:@"deviceToken"];
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"registeredForRemoteNotifications"
                                                    body:@{@"token": deviceTokenStr}];
    
}

- (void) registeredForRemoteNotificationsError:(NSNotification *) notification {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"registeredForRemoteNotifications"
                                                    body:@{@"error": @"Could not register for remote noticiations"}];
}

- (void) receivedRemoteNotification:(NSNotification *) notification {
    NSDictionary *userInfo = notification.userInfo;
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"receivedRemoteNotification" body: userInfo];
}

- (void) receivedRemoteNotificationOnStart:(NSNotification *) notification {
    startupNotification = notification.userInfo;
}

RCT_EXPORT_METHOD(getStartupNotifications: (RCTResponseSenderBlock)callback)
{
    
    if (startupNotification) {
        callback(@[[NSNull null], startupNotification]);
    } else {
        callback(@[[NSNull null], [NSNull null]]);
    }
}


@end
