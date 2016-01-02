var React = require("react-native");

var {
    NativeModules,
    DeviceEventEmitter
} = React;

const REGISTERED_FOR_REMOTE = "registeredForRemoteNotifications";
const REGISTERED_FOR_REMOTE_ERROR = "registeredForRemoteNotificationsError";
const RECEIVED_REMOTE = "receivedRemoteNotification";

module.exports = {
    requestPermissions: function(callback) {
        NativeModules.RemotePushManager.requestPermissions();

        DeviceEventEmitter.addListener(
            REGISTERED_FOR_REMOTE, function(notification) {
                callback(null, notification);
            }
        );

        DeviceEventEmitter.addListener(
            REGISTERED_FOR_REMOTE_ERROR, function(error) {
                callback("Couldn't register for notifications");
            }
        )
    },

    setListenerForNotifications: function(callback) {
        NativeModules.RemotePushManager.getStartupNotifications(function(err, startupNotification) {
            if (startupNotification) {
                startupNotification.startup = true;
                callback(startupNotification);
            }

        });

        DeviceEventEmitter.addListener(
            RECEIVED_REMOTE, function(notification) {
                notification.startup = false;
                callback(notification);
            }
        );
    }
};