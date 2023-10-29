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
