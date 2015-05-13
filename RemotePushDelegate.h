#import "AppDelegate.h"

@interface AppDelegate(RemotePushDelegate)

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

@end