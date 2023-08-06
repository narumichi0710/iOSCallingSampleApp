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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    public init() {}

    public var body: some Scene {
        WindowGroup {
            RootView(factory: ServiceFactoryImpl())
        }
    }
}
