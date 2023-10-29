//
//  User.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var profilePictureURL: String?
    var status: UserStatus = .online
    
    init(id: String, firstName: String, lastName: String, email: String, profilePictureURL: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePictureURL = profilePictureURL
    }

    init?(documentData: [String: Any]) {
        guard let id = documentData["id"] as? String,
              let firstName = documentData["firstName"] as? String,
              let lastName = documentData["lastName"] as? String,
              let email = documentData["email"] as? String else {
            return nil
        }

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePictureURL = documentData["profilePictureURL"] as? String
    }
}


enum UserStatus: String, Codable {
    case online
    case offline
}

#warning("dummy data")
extension User {
    static var dummyUsers: [User] = [User(id: "1", firstName: "Alice", lastName: "Johnson", email: "alice.johnson@example.com", profilePictureURL: nil), User(id: "2", firstName: "Bob", lastName: "Smith", email: "bob.smith@example.com", profilePictureURL: nil), User(id: "3", firstName: "Charlie", lastName: "Brown", email: "charlie.brown@example.com", profilePictureURL: nil), User(id: "4", firstName: "Daisy", lastName: "Miller", email: "daisy.miller@example.com", profilePictureURL: nil), User(id: "5", firstName: "Eddie", lastName: "White", email: "eddie.white@example.com", profilePictureURL: nil), User(id: "6", firstName: "Fiona", lastName: "Green", email: "fiona.green@example.com", profilePictureURL: nil), User(id: "7", firstName: "George", lastName: "Black", email: "george.black@example.com", profilePictureURL: nil), User(id: "8", firstName: "Hannah", lastName: "Gray", email: "hannah.gray@example.com", profilePictureURL: nil)]
}
