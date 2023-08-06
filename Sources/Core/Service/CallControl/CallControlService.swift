//
//  File.swift
//  
//
//  Created by Narumichi Kubo on 2023/08/06.
//

import Foundation
import CallKit

public protocol CallControlService {
    func setup()
    func startIncomingCall(uuid: UUID, handle: String, completion: @escaping (Error?) -> Void)
    func startOutgoingCall(uuid: UUID, handle: String, completion: @escaping (Error?) -> Void)
}

public final class CallControlServiceImpl: NSObject, CallControlService {
    private let callController: CXCallController
    private let provider: CXProvider

    public override init() {
        callController = CXCallController()

        let configuration = CXProviderConfiguration()
        configuration.includesCallsInRecents = false
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = true
        configuration.supportedHandleTypes = [.phoneNumber]
        
        provider = CXProvider(configuration: configuration)

        super.init()

        provider.setDelegate(self, queue: nil)
    }

    public func setup() {}

    public func startIncomingCall(
        uuid: UUID,
        handle: String,
        completion: @escaping (Error?) -> Void = { _ in }
    ) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        provider.reportNewIncomingCall(with: uuid, update: update, completion: completion)
    }

    public func startOutgoingCall(
        uuid: UUID,
        handle: String,
        completion: @escaping (Error?) -> Void = { _ in }
    ) {
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        let transaction = CXTransaction(action: startCallAction)
        callController.request(transaction, completion: completion)
    }
}

extension CallControlServiceImpl: CXProviderDelegate {
    public func providerDidReset(_ provider: CXProvider) {
        // TODO: 通話がリセットされたときの処理
    }
    
    public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // TODO: 通話に応答するときの処理
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // TODO: 通話を終了するときの処理
        action.fulfill()
        
    }
}

public final class CallControlServiceStub: CallControlService {
    public func setup() {}
    public func startIncomingCall(uuid: UUID, handle: String, completion: @escaping (Error?) -> Void) {}
    public func startOutgoingCall(uuid: UUID, handle: String, completion: @escaping (Error?) -> Void) {}
}
