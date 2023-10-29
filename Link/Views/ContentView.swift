//
//  ContentView.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import SwiftUI
import Observation
enum Screen {
    case friends, link
}
struct ContentView: View {
    @State var currentScreen: Screen = .friends
    @StateObject var LinkVM = NIService()
    var body: some View {
        VStack {
            switch currentScreen {
            case .link:
                LinkView(currentScreen: $currentScreen, vm: LinkVM)
                    .transition(.opacity)
                    .onAppear() {
                        LinkVM.startup()
                        
                    }
            case .friends:
                FriendsView(currentScreen: $currentScreen)
            }
        }
        
    }
}

    

#Preview {
    ContentView()
}
