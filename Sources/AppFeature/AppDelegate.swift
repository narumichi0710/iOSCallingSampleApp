//
//  AppDelegate.swift
//  
//
//  Created by Narumichi Kubo on 2023/08/06.
//

import Service
import Foundation
import FirebaseCore
import FirebaseMessaging
import PushKit
import CallKit
import UIKit

public class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    
    let factory: ServiceFactory = ServiceFactoryImpl()
    private lazy var notificationService: NotificationService = factory.notificationService
    private lazy var callControllService: CallControlService = factory.callControllService
    
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        debugPrint("applicationState: \(application.applicationState.localize)")

        FirebaseApp.configure()
        notificationService.setup()
        callControllService.setup()
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        return true
    }
    
    public func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().token { token, error in
            if let error = error {
                debugPrint("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                debugPrint("FCM registration token: \(token)")
            }
        }
    }
    
    public func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        debugPrint("Failed register remote notifications: \(error.localizedDescription)")
    }
    
    public func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        debugPrint("did Receive Remote Notification: \(userInfo)")
        return .newData
    }
    
    public func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        debugPrint("fcm token: \(Messaging.messaging().fcmToken ?? "nil")")
    }
}

extension UIApplication.State {
    var localize: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .background:
            return "background"
        @unknown default:
            return "unknown"
        }
    }
}
