//
//  FriendsView.swift
//  Link
//
//  Created by Nathan Cree on 10/28/23.
//

import SwiftUI

struct FriendsView: View {
    @Binding var currentScreen: Screen
    @Binding var userID: String
    @StateObject var vm = FriendsViewModel()
    var body: some View {
        VStack {
            HStack {
                Text("Link")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "tray.and.arrow.down.fill")
                        .foregroundColor(.black)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.trailing, 20)
                }
            }
            .padding(.bottom, 20)
            
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
                                    .foregroundStyle(.black)
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
                            .onTapGesture {
                                withAnimation {
                                    userID = friend.id
                                    currentScreen = .link
                                }
                            }
                            
                            Divider()
                        }
                    }
                }
            }
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
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
