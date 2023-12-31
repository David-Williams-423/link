//
//  TabBarView.swift
//  Link
//
//  Created by Lauren Ferlito on 10/28/23.
//

import SwiftUI

enum Tabs: Int {
    case link = 0
    case friends = 1
}

struct TabBarView: View {
    @Binding var selectedTab: Tabs
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    selectedTab = .friends
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(selectedTab == .friends ? .white : .black)
                }
                Spacer()
                Button(action: {
                    selectedTab = .link
                }) {
                    Image(systemName: "link")
                        .foregroundColor(selectedTab == .link ? .white : .black)
                }
                Spacer()
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(40.0)
            
        }
        .padding()
    }
}

struct TabViewButton: View {
    var image: String
//    var name: String
    var isActive: Bool
    var body: some View {
        Image(systemName: image)
            .foregroundColor(.white)
    }
}

//#Preview {
//    TabBarView()
//}
