//
//  SwiftUIApp.swift
//  
//
//  Created by Narumichi Kubo on 2023/08/04.
//

import SwiftUI
import FirebaseCore
import Service
import FirebaseMessaging

public struct SwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    public init() {}

    public var body: some Scene {
        WindowGroup {
            RootView(factory: ServiceFactoryImpl())
        }
    }
}
public class AppDelegate: NSObject, UIApplicationDelegate {
    let factory: ServiceFactory = ServiceFactoryImpl()
    private lazy var notificationService: NotificationService = factory.notificationService

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        notificationService.setup()
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
        debugPrint("Failed to register remote notifications: \(error.localizedDescription)")
    }

    public func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        debugPrint("did Receive Remote otification: \(userInfo)")
        return .newData
    }
}

