var RemotePushManager = require("NativeModules").RemotePushManager;
var React = require("react-native");

var {
    DeviceEventEmitter
} = React;

const REGISTERED_FOR_REMOTE = "registeredForRemoteNotifications";
const RECEIVED_REMOTE = "receivedRemoteNotification";

module.exports = {
    requestPermissions: function(callback) {
        RemotePushManager.requestPermissions();

        DeviceEventEmitter.addListener(
            REGISTERED_FOR_REMOTE, function(notification) {
                callback(null, notification);
            }
        );
    },

    setListenerForNotifications: function(callback) {
        RemotePushManager.getStartupNotifications(function(err, startupNotification) {
            if (startupNotification) {
                callback(startupNotification);
            }

        });

        DeviceEventEmitter.addListener(
            RECEIVED_REMOTE, function(notification) {
                callback(notification);
            }
        );
    }
};