//
//  FriendRequestCellView.swift
//  Link
//
//  Created by David Williams on 10/29/23.
//

import SwiftUI

struct FriendRequestCellView: View {
    @ObservedObject var viewModel: FriendRequestCellViewModel

    var body: some View {
        HStack(spacing: 15) {
            // Display profile picture
            if let urlString = viewModel.requester?.profilePictureURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:

                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading) {
                Text(viewModel.requester?.firstName ?? "Unknown")
                    .font(.headline)
                Text("Wants to be your friend")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Action buttons
            if viewModel.friendRequest.status == .pending {
                Button(action: {
                    Task {
                        await viewModel.acceptRequest()
                    }
                }) {
                    Text("Accept")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }

                Button(action: {
                    Task {
                        await viewModel.declineRequest()
                    }
                }) {
                    Text("Decline")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
            } else if viewModel.friendRequest.status == .accepted {
                Text("Accepted")
                    .foregroundColor(.green)
            } else {
                Text("Declined")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    FriendRequestCellView(viewModel: .init(friendRequest: FriendRequest(fromUserID: "gEpmphA60sgjwcZpsdXwzdeQjTP2", toUserID: "SqktneOzV3OSMJUtWwDuECdwDBF3")))
}
