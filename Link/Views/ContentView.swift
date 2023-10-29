//
//  ContentView.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import SwiftUI
import Observation

struct ContentView: View {
    @State var selectedTab: Tabs = .link
    @StateObject var LinkVM = NIService()
    var body: some View {
        VStack {
            switch selectedTab {
            case .link:
                LinkView(selectedTab: $selectedTab, vm: LinkVM)
            case .friends:
                FriendsView(selectedTab: $selectedTab)
            case .settings:
                SettingView(selectedTab: $selectedTab)
            }
        }
        .onAppear() {
            LinkVM.startup()
        }
    }
}

    

#Preview {
    ContentView()
}
