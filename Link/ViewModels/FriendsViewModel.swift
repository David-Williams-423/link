//
//  FriendsViewModel.swift
//  Link
//
//  Created by Nathan Cree on 10/29/23.
//

import Foundation

class FriendsViewModel: ObservableObject {
    private let service = FireBaseService()
    @Published var friendRequestList: [FriendRequest] = []
    @Published var friendsList: [User] = []
    
    init() {
        self.friendsList = User.dummyUsers
//        setFriendsList(friends: getAllFriends())
//        getFriendRequests()
    }
    
    private func setFriendsList(friends: [User]) {
        self.friendsList = friends
    }
}

extension FriendsViewModel {
    private func getAllFriends() -> [User] {
        Task {
            do {
                let friendsList = try await service.getAllFriends(forUserID: (service.currentUser?.id)!)
            } catch {
                print(error)
            }
        }
        return friendsList
    }
    
    func getFriendRequests() {
        Task {
            do {
                self.friendRequestList = try await service.fetchFriendRequests(forUserID: (service.currentUser?.id)!)
            } catch {
                print(error)
            }
        }
    }
    
    
}
