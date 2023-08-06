//
//  ServiceFactory.swift
//  
//
//  Created by Narumichi Kubo on 2023/08/06.
//

import Foundation

public protocol ServiceFactory {
    var notificationService: NotificationService { get }
}

public final class ServiceFactoryImpl: ServiceFactory {
    public lazy var notificationService: NotificationService = NotificationServiceImpl(
        callControllService: CallControlServiceImpl()
    )
    public init() {}
}

public final class ServiceFactoryStub: ServiceFactory {
    public var notificationService: NotificationService = NotificationServiceStub(
        callControllService: CallControlServiceStub()
    )
    public init() {}
}
