//
//  User.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import Foundation

struct User: Identifiable, Codable {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var profilePictureURL: String?
}
