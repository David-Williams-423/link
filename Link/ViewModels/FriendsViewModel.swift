//
//  FriendsViewModel.swift
//  Link
//
//  Created by Nathan Cree on 10/29/23.
//

import Foundation

@MainActor
class FriendsViewModel: ObservableObject {
    private let service = FireBaseService.shared
    @Published var friendRequestList: [FriendRequest] = []
    @Published var friendsList: [User] = []
    @Published var searchTerm: String = ""
    @Published var searchResults: [User] = []
    
    init() {
        getAllUsers()
    }
    
    private func setFriendsList(friends: [User]) {
        self.friendsList = friends
    }
}

extension FriendsViewModel {
    func getAllFriends(){
        
        Task {
            do {
                self.friendsList = try await service.getAllFriends(forUserID: (service.currentUser?.id)!)
            } catch {
                print(error)
            }
        }
    }
    
    func getAllUsers() {
        Task {
            do {
                self.friendsList = try await service.getAllUsers(excludingUserID: service.currentUser?.id)
            } catch {
                print(error)
            }
        }
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
    
    func searchFriends(searchTerm: String) {
        Task {
            do {
                self.searchResults = try await service.searchUsersByFirstName(searchTerm: searchTerm)
            } catch {
                print(error)
            }
        }
    }
}
