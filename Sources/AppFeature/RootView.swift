//
//  ContentView.swift
//  App
//
//  Created by Narumichi Kubo on 2023/08/04.
//

import SwiftUI
import Service

public struct RootView: View {
    private let factory: ServiceFactory
    
    public init(factory: ServiceFactory) {
        self.factory = factory
    }

    public var body: some View {
        HStack(spacing: 16) {
            Button("発信") {
                factory
                    .callControllService
                    .startOutgoingCall(
                        uuid: UUID(),
                        handle: "Test",
                        completion: { _ in}
                    )
            }
            
            Button("着信") {
                factory
                    .callControllService
                    .startIncomingCall(
                        uuid: UUID(),
                        handle: "Test",
                        completion: { _ in}
                    )
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(factory: ServiceFactoryStub())
    }
}
