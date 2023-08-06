//
//  NotificationService.swift
//  
//
//  Created by Narumichi Kubo on 2023/08/06.
//

import Foundation
import UserNotifications
import Combine


public protocol NotificationService {
    func setup()
    func registerDeviceToken(_ deviceToken: Data)
}

public final class NotificationServiceImpl: NSObject, NotificationService {
    private let userNotificationCenter = UNUserNotificationCenter.current()

    public override init() {
        super.init()
    }

    public func setup() {
        userNotificationCenter.delegate = self
        requestNotificationAuthorization()
    }

    private func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        userNotificationCenter.requestAuthorization(options: authOptions) { _, _ in
            debugPrint("UNUserNotification requestAuthorization completed")
        }
    }

    public func registerDeviceToken(_ deviceToken: Data) {}
}

@MainActor
extension NotificationServiceImpl: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        debugPrintNotificationInfo("willPresent", from: notification.request.content.userInfo)
        return [.banner, .badge, .sound]
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        debugPrintNotificationInfo("didReceive", from: userInfo)
        handleUserData(from: userInfo)
    }

    private func debugPrintNotificationInfo(_ prefix: String, from userInfo: [AnyHashable: Any]) {
        debugPrint("\(prefix): \(userInfo)")
    }

    private func handleUserData(from userInfo: [AnyHashable: Any]) {
        if let data = userInfo["data"] as? [String: Any] {
            // TODO:
        }
    }
}

public final class NotificationServiceStub: NotificationService {
    public func setup() {}
    public func registerDeviceToken(_ deviceToken: Data) {}
}
