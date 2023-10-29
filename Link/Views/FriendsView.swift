//
//  FriendsView.swift
//  Link
//
//  Created by Nathan Cree on 10/28/23.
//

import SwiftUI

struct FriendsView: View {
    @Binding var currentScreen: Screen
    var body: some View {
        VStack {
            Text("FriendsView")
                .onTapGesture {
                    withAnimation {
                        currentScreen = .link
                    }
                }
        }
    }
}

struct SettingView: View {
    @Binding var selectedTab: Tabs
    var body: some View {
        VStack {
            Text("Settings")
        }
    }
}

//#Preview {
//    FriendsView()
//}
