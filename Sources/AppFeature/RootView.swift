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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(factory: ServiceFactoryStub())
    }
}
