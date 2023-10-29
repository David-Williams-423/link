//
//  FriendRequestsCellViewModel.swift
//  Link
//
//  Created by David Williams on 10/29/23.
//

import Foundation

class FriendRequestCellViewModel: ObservableObject {
    @Published var friendRequest: FriendRequest
    @Published var requester: User?
    private var firebaseService = FireBaseService.shared

    init(friendRequest: FriendRequest) {
        self.friendRequest = friendRequest
        fetchRequester()
    }

    func fetchRequester() {
        Task {
            if let user = try? await firebaseService.searchUsersByFirstName(searchTerm: friendRequest.fromUserID).first {
                self.requester = user
            }
        }
    }

    func acceptRequest() async {
        do {
            try await firebaseService.addFriend(request: friendRequest)
            friendRequest.status = .accepted
        } catch {
            print("Failed to accept friend request: \(error)")
        }
    }

    func declineRequest() async {
        do {
            try await firebaseService.rejectFriend(request: friendRequest)
            friendRequest.status = .declined
        } catch {
            print("Failed to decline friend request: \(error)")
        }
    }
}
