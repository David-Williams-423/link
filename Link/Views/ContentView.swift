//
//  ContentView.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import SwiftUI
import Observation

struct ContentView: View {
    @State var selectedTab: Tabs = .friends
    @StateObject var LinkVM = NIService()
    var body: some View {
        VStack {
            switch selectedTab {
            case .link:
                LinkView(selectedTab: $selectedTab, vm: LinkVM)
                    .transition(.opacity)
                    .onAppear() {
                        LinkVM.startup()
                        
                    }
            case .friends:
                FriendsView(selectedTab: $selectedTab)
                    .transition(.opacity)
            }
        }
    }
}

    

#Preview {
    ContentView()
}
