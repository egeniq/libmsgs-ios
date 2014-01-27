libmsgs-ios
===========
Msgs.io library for iOS.

Dependencies
============
No external dependencies.

Setup
=====
Register your bundle with Apple to enable push notifications. read more here: http://developer.apple.com/library/mac/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/ProvisioningDevelopment/ProvisioningDevelopment.html#//apple_ref/doc/uid/TP40008194-CH104-SW1

Add the following fields to your project .plist files:
MSGSAPIKey - The API key you received.
MSGSAPIURL - The Msgs.io API endpoint.

Sample Project
==============
The sample project has a simple interface that registers the device with the server, allows you to subscribe to channels and lists your subscriptions.
