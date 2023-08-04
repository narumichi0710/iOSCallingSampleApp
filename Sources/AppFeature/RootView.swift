//
//  ContentView.swift
//  App
//
//  Created by Narumichi Kubo on 2023/08/04.
//

import SwiftUI

public struct RootView: View {
    public init() {}
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
        RootView()
    }
}
