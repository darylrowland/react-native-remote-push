#import "RCTBridgeModule.h"

@interface RCTRemotePushManager: NSObject<RCTBridgeModule>

- (void)requestPermissions;
- (void) registeredForRemoteNotifications:(NSNotification *) notification;

@end