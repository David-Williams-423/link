//
//  ContentView.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var manager = NotificationManager()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button {
                Task {
                    await manager.request()
                }
            } label: {
                Text("Request Notification\n Permissions")
            }
            .buttonStyle(.bordered)
            .disabled(manager.hasPermission)
            .task {
                await manager.getAuthStatus()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
