//
//  FriendsView.swift
//  Link
//
//  Created by Nathan Cree on 10/28/23.
//

import SwiftUI

struct FriendsView: View {
    @Binding var selectedTab: Tabs
    @StateObject var vm = FriendsViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.friendsList) { friend in
                    HStack {
                        Image(friend.profilePictureURL ?? "") //ask about profile pics
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        Text("\(friend.firstName) \(friend.lastName)")
                            .font(.title2)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        Image(systemName: friend.status == .online ? "wifi" : "wifi.slash")
                            .foregroundColor(friend.status == .online ? .green : .gray)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        Divider()
                            .padding([.leading, .trailing])
                            .background(Color.gray.opacity(0.5)), alignment: .bottom
                    )
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
            TabBarView(selectedTab: $selectedTab)
        }
    }
}
