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
            case .friends:
                FriendsView(currentScreen: $currentScreen)
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
