//
//  FriendRequestsView.swift
//  Link
//
//  Created by David Williams on 10/29/23.
//

import SwiftUI

struct FriendRequestsView: View {
    @ObservedObject var viewModel = FriendRequestsViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.friendRequests, id: \.id) { request in
                FriendRequestCellView(viewModel: FriendRequestCellViewModel(friendRequest: request))
                    .padding(.vertical, 10)
            }
            .onAppear {
                viewModel.fetchFriendRequests()
            }
            
        }
        
    }
}


#Preview {
    FriendRequestsView()
}
