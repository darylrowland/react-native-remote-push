#import "RemotePushDelegate.h"
#import <objc/runtime.h>

@implementation AppDelegate(RemotePushDelegate)

NSDictionary *launchNotification;


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:deviceToken forKey:@"deviceToken"];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"registeredForRemoteNotifications"
     object:self userInfo:userInfo];
}

+ (void)load
{
    Method original, swizzled;
    
    original = class_getInstanceMethod(self, @selector(init));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_init));
    method_exchangeImplementations(original, swizzled);
}

- (AppDelegate *)swizzled_init
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNotificationChecker:) name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
    
    // This actually calls the original init method over in AppDelegate. Equivilent to calling super
    // on an overrided method, this is not recursive, although it appears that way. neat huh?
    return [self swizzled_init];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // TODO Handle this on Manager side
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:@"deviceToken"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"registeredForRemoteNotificationsError"
     object:self userInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)]) {
        appState = application.applicationState;
    }
    
    if (appState == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"receivedRemoteNotification"
         object:self userInfo:userInfo];
        
    } else {
        //save it for later
        launchNotification = userInfo;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (launchNotification) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"receivedRemoteNotification"
         object:self userInfo:launchNotification];
        
        launchNotification = nil;
    }
}

- (void)createNotificationChecker:(NSNotification *)notification
{
    if (notification)
    {
        NSDictionary *launchOptions = [notification userInfo];
        if (launchOptions) {
            launchNotification = [launchOptions objectForKey: @"UIApplicationLaunchOptionsRemoteNotificationKey"];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"receivedRemoteNotificationOnStart"
             object:self userInfo:launchNotification];
        }
    }
}

@end