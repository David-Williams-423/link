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
        VStack {
            Text("Friends!")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
            
            Spacer()
            
            ScrollView {
                VStack {
                    ForEach(vm.friendsList) { friend in
                        VStack {
                            HStack {
                                Image(friend.profilePictureURL ?? "") //ask about profile pics
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                                
                                Text("\(friend.firstName) \(friend.lastName)")
                                    .font(.title2)
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                                Image(systemName: friend.status == .online ? "wifi" : "wifi.slash")
                                    .foregroundColor(friend.status == .online ? .green : .gray)
                                    .font(.subheadline)
                                    .padding(.trailing, 20)
                            }
                            .frame(minHeight: 75)
                            .background(Color.white)
                            .cornerRadius(8)
                            
                            Divider()
                        }
                    }
                }
            }
            .cornerRadius(15)
            .padding(.horizontal, 20)
            
            Button {
                
            } label: {
                Text("Add Friend")
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .cornerRadius(8)
            }
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
