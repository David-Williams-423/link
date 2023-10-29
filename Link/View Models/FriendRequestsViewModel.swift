//
//  FriendRequestsViewModel.swift
//  Link
//
//  Created by David Williams on 10/29/23.
//

import Foundation

@MainActor
class FriendRequestsViewModel: ObservableObject {
    @Published var friendRequests: [FriendRequest] = []
    private var firebaseService = FireBaseService.shared
    
    func fetchFriendRequests() {
        Task {
            do {
                await firebaseService.fetchUser()
                if let currentUser = firebaseService.currentUser {
                    self.friendRequests = try await firebaseService.fetchFriendRequests(forUserID: currentUser.id)
                }
            } catch {
                print("Error fetching friend requests: \(error)")
            }
        }
    }
    
    func acceptFriendRequest(request: FriendRequest) {
        Task {
            do {
                try await firebaseService.addFriend(request: request)
                self.friendRequests.removeAll { $0.id == request.id }
            } catch {
                print("Error accepting friend request: \(error)")
            }
        }
    }
    
    func declineFriendRequest(request: FriendRequest) {
        Task {
            do {
                try await firebaseService.rejectFriend(request: request)
                self.friendRequests.removeAll { $0.id == request.id }
            } catch {
                print("Error declining friend request: \(error)")
            }
        }
    }
}
