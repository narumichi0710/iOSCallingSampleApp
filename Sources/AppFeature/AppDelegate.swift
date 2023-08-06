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

public class AppDelegate: NSObject, UIApplicationDelegate, PKPushRegistryDelegate {

    let factory: ServiceFactory = ServiceFactoryImpl()
    private lazy var notificationService: NotificationService = factory.notificationService
    private lazy var callControllService: CallControlService = factory.callControllService
    
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        notificationService.setup()
        application.registerForRemoteNotifications()
        
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
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
        debugPrint("did Receive Remote otification: \(userInfo)")
        return .newData
    }

    public func pushRegistry(
        _ registry: PKPushRegistry,
        didUpdate pushCredentials: PKPushCredentials,
        for type: PKPushType
    ) {
        guard type == .voIP else {
            debugPrint("PKPushType is not voIP: \(registry), \(pushCredentials)")
            return
        }
        let deviceToken = (pushCredentials.token as NSData)
        // TODO: pushCredentialsをサーバーに保存
    }

    public func pushRegistry(
        _ registry: PKPushRegistry,
        didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType,
        completion: @escaping () -> Void
    ) {
        guard type == .voIP else {
            debugPrint("PKPushType is not voIP: \(registry), \(payload)")
            return
        }
        // 着信をリクエスト
        callControllService.startIncomingCall(
            uuid: UUID(),
            handle: "",
            completion: { error in
                debugPrint("Failed start incoming call: \(String(describing: error))")
            })
        completion()
    }
}

