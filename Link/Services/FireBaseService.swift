//
//  FireBaseService.swift
//  Link
//
//  Created by Nathan Cree on 10/28/23.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation

class FireBaseService {
    public static var shared = FireBaseService()
    
    var userSession: FirebaseAuth.User?
    var currentUser: User?
    
    let db = Firestore.firestore()
    let storage = Storage.storage()

    init(userSession: FirebaseAuth.User? = nil, currentUser: User? = nil) {
        self.userSession = userSession
        
        Task {
            await fetchUser()
        }
    }
    
    // MARK: - Authentication
    
    func createUser(withEmail email: String, password: String, firstName: String, lastName: String, profileImageData: UIImage?) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            var profilePictureURL: String?
            if let imageData = profileImageData {
                profilePictureURL = try await self.uploadProfilePicture(userID: result.user.uid, image: imageData)
            }
            
            let user = User(id: result.user.uid, firstName: firstName, lastName: lastName, email: email, profilePictureURL: profilePictureURL)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await self.db.collection("users").document(user.id).setData(encodedUser)
            await self.fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }

    func uploadProfilePicture(userID: String, image: UIImage) async throws -> String {
        // Convert the UIImage to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            throw NSError(domain: "ImageConversionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG"])
        }

        let storageRef = self.storage.reference().child("profilePictures/\(userID).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = storageRef.putData(imageData, metadata: metadata)
        let downloadURL = try await storageRef.downloadURL()
        
        return downloadURL.absoluteString
    }

    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
            Task {
                await fetchUser()
            }
        } catch {
            print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await db.collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    // MARK: - Friends

    func searchUsersByFirstName(searchTerm: String) async throws -> [User] {
        let snapshot = try await db.collection("users").getDocuments()
        let users = snapshot.documents.compactMap { document -> User? in
            let user = try? document.data(as: User.self)
            if user?.firstName.lowercased() == searchTerm.lowercased() {
                return user
            }
            return nil
        }
        return users
    }
    
    func sendFriendRequest(fromUserID: String, toUserID: String) {
        let requestData = [
            "fromUserID": fromUserID,
            "toUserID": toUserID,
            "status": "pending"
        ]
        self.db.collection("friendRequests").addDocument(data: requestData)
    }
    
    func fetchFriendRequests(forUserID userID: String) async throws -> [FriendRequest] {
        let query = self.db.collection("friendRequests").whereField("toUserID", isEqualTo: userID).whereField("status", isEqualTo: "pending")
        
        let snapshot = try await query.getDocuments()
        var requests: [FriendRequest] = []

        for document in snapshot.documents {
            if let request = FriendRequest(data: document.data()) {
                requests.append(request)
            }
        }
        
        return requests
    }
    
    func addFriend(request: FriendRequest) async throws {
        let requestRef = self.db.collection("friendRequests").document(request.id!)
        try await requestRef.updateData(["status": "accepted"])

        let user1Ref = self.db.collection("users").document(request.fromUserID)
        let user2Ref = self.db.collection("users").document(request.toUserID)

        try await user1Ref.updateData(["friendIDs": FieldValue.arrayUnion([request.toUserID])])
        try await user2Ref.updateData(["friendIDs": FieldValue.arrayUnion([request.fromUserID])])
    }

    func rejectFriend(request: FriendRequest) async throws {
        let requestRef = self.db.collection("friendRequests").document(request.id!)
        try await requestRef.updateData(["status": "declined"])
    }
    
    func getAllFriends(forUserID userID: String) async throws -> [User] {
        // Fetch the user document to get the friendIDs array
        let userRef = self.db.collection("users").document(userID)
        let userDoc = try await userRef.getDocument()

        guard let userData = userDoc.data(), let friendIDs = userData["friendIDs"] as? [String] else {
            // Return an empty array or throw an error if friendIDs are not found
            return []
        }

        // Fetch details for each friend using their IDs
        var friends: [User] = []
        for friendID in friendIDs {
            let friendDoc = try await db.collection("users").document(friendID).getDocument()
            if let friendData = friendDoc.data(), let friend = User(documentData: friendData) {
                friends.append(friend)
            }
        }

        return friends
    }
    
    func updateUserStatus(userID: String, to status: UserStatus) async throws {
        try await self.db.collection("users").document(userID).updateData(["status": status.rawValue])
    }
}
