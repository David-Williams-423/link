//
//  FriendsView.swift
//  Link
//
//  Created by Nathan Cree on 10/28/23.
//

import SwiftUI

struct FriendsView: View {
    @Binding var selectedTab: Tabs
    var body: some View {
        VStack {
            Text("FriendsView")
            TabBarView(selectedTab: $selectedTab)
        }
    }
}

struct SettingView: View {
    @Binding var selectedTab: Tabs
    var body: some View {
        VStack {
            Text("Settings")
            TabBarView(selectedTab: $selectedTab)
        }
    }
}

//#Preview {
//    FriendsView()
//}
