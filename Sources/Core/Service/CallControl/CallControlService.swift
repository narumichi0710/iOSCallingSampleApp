//
//  File.swift
//  
//
//  Created by Narumichi Kubo on 2023/08/06.
//

import Foundation
import CallKit
import PushKit

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

    public func setup() {
        let voipRegistry = PKPushRegistry(queue: .main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    public func startIncomingCall(
        uuid: UUID,
        handle: String,
        completion: @escaping (Error?) -> Void = { _ in }
    ) {
        debugPrint("start incoming call: \(uuid), \(handle)")
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        provider.reportNewIncomingCall(with: uuid, update: update, completion: completion)
    }

    public func startOutgoingCall(
        uuid: UUID,
        handle: String,
        completion: @escaping (Error?) -> Void = { _ in }
    ) {
        debugPrint("start outgoing call: \(uuid), \(handle)")
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        let transaction = CXTransaction(action: startCallAction)
        callController.request(transaction, completion: completion)
    }
}


extension CallControlServiceImpl: PKPushRegistryDelegate {

    public func pushRegistry(
        _ registry: PKPushRegistry,
        didUpdate pushCredentials: PKPushCredentials,
        for type: PKPushType
    ) {
        debugPrint("did update pushCredentials: \(registry), \(pushCredentials), \(type)")
        guard type == .voIP else {
            debugPrint("PKPushType is not voIP")
            return
        }
        
        let pkid = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        debugPrint("your device token: \(pkid)")
    }

    public func pushRegistry(
        _ registry: PKPushRegistry,
        didInvalidatePushTokenFor type: PKPushType
    ) {
        print("did invalidate push token for: \(registry), \(type)")
    }
    
    public func pushRegistry(
        _ registry: PKPushRegistry,
        didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType,
        completion: @escaping () -> Void
    ) {
        print("did receive incoming push with: \(registry), \(payload), \(type)")

        guard type == .voIP else {
            debugPrint("PKPushType is not voIP")
            return
        }
        // 着信をリクエスト
        startIncomingCall(
            uuid: UUID(),
            handle: "",
            completion: { error in
                debugPrint("Failed start incoming call: \(String(describing: error))")
            }
        )
        completion()
    }
}

extension CallControlServiceImpl: CXProviderDelegate {
    public func providerDidReset(_ provider: CXProvider) {
        debugPrint("provider did reset: \(provider)")
        // TODO: 通話がリセットされたときの処理
    }
    
    public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        debugPrint("provider answer call: \(provider), \(action)")
        // TODO: 通話に応答するときの処理
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        debugPrint("provider finish call: \(provider), \(action)")
        // TODO: 通話を終了するときの処理
        action.fulfill()
    }
}

public class CallControlServiceStub: CallControlService {
    public func setup() {}
    public func startIncomingCall(uuid: UUID, handle: String, completion: @escaping (Error?) -> Void) {}
    public func startOutgoingCall(uuid: UUID, handle: String, completion: @escaping (Error?) -> Void) {}
}
