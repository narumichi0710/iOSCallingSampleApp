//
//  ServiceFactory.swift
//  
//
//  Created by Narumichi Kubo on 2023/08/06.
//

import Foundation

public protocol ServiceFactory {
    var notificationService: NotificationService { get }
    var callControllService: CallControlService { get }
}

public final class ServiceFactoryImpl: ServiceFactory {
    public lazy var notificationService: NotificationService = NotificationServiceImpl()
    public lazy var callControllService: CallControlService = CallControlServiceImpl()

    public init() {}

}

public final class ServiceFactoryStub: ServiceFactory {
    public var notificationService: NotificationService = NotificationServiceStub()
    public var callControllService: CallControlService = CallControlServiceStub()

    public init() {}
}
