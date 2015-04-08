# react-native-remote-push
React Native module that allows you to:
 1. Request push notification permissions
 2. Get the device token back from the request
 3. Subscribe to remote push notifications

It's very basic code for now, but provides functionality above and beyond the PushNotificationIOS class that is provided as standard in react native.

It borrows heavily from the way that the Cordova Push Plugin works, so massive thanks to those guys, over here: https://github.com/phonegap-build/PushPlugin

... more to come!

I'm not too sure how to distribute this as a module (NPM?), so if you want to help me do that, feel free to make some pull requests.

## Examples
### Getting started
Copy all of the files to your XCode directory, and add them to your project. Then, when you want to use the module, require the RemotePushIOS class, e.g.

```
var RemotePushIOS = require("./../RemotePush/RemotePushIOS");
```

Note: you'll also need to add the following line to your AppDelegate.m: 

```
#import "RemotePushDelegate.h"
```

### Registering For Push Notifications

```
RemotePushIOS.requestPermissions(function(err, data) {
  if (err) {
    console.log("Could not register for push");
  } else {
    // On success, data will contain your device token. You're probably going to want to send this to your server.
    console.log(data.token);
  }
});
```

### Adding a notification listener
RemotePushIOS will listen out for remote notifications on startup or when your application is active. To receive these notifications in your code, you need to set a listener. Ideally you should set this on your top-level react component.

You can add a listener in the following way:

```
componentWillMount: function() {
     // Add the listener when the component mounts
     RemotePushIOS.setListenerForNotifications(this.receiveRemoteNotification);
 },

receiveRemoteNotification: function(notification) {
     // Your code to run when the alert fires
     AlertIOS.alert(
         'Notification received',
         notification.aps.alert,
         [
             {text: 'OK', onPress: () => console.log('Ok pressed!')}
         ]
     );

 }
```    

The notification will contain an aps object with your alert as well as any custom payload data you have.



