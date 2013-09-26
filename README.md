libmsgs-ios
===========
Msgs.io Notification Library for iOS

Dependencies
============
AFNetworking (https://github.com/AFNetworking/AFNetworking) - Add the *.h and *.m files to your project.

Setup
=====
Register your bundle with apple to enable push notifications. read more here: http://developer.apple.com/library/mac/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/ProvisioningDevelopment/ProvisioningDevelopment.html#//apple_ref/doc/uid/TP40008194-CH104-SW1

Add the following fields to your project .plist files:
ENSAppId  - The application ID you received.
ENSAPIURL - The Msgs.io API endpoint.

Sample Project
==============
The sample project has a simple interface that registers the device with the server, allows you to subscribe to channels and lists your subscriptions.
