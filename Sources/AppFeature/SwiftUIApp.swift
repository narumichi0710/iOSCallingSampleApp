//
//  SwiftUIApp.swift
//  
//
//  Created by Narumichi Kubo on 2023/08/04.
//

import SwiftUI
import FirebaseCore
import Service

public struct SwiftUIApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            RootView(factory: ServiceFactoryImpl())
        }
    }
}

public class AppDelegate: NSObject, UIApplicationDelegate {

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

