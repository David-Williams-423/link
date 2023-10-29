//
//  FriendRequest.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import Foundation

struct FriendRequest: Codable {
    var id: String?
    let fromUserID: String
    let toUserID: String
    var status: RequestStatus

    enum RequestStatus: String, Codable {
        case pending = "pending"
        case accepted = "accepted"
        case declined = "declined"
    }

    init(fromUserID: String, toUserID: String) {
        self.fromUserID = fromUserID
        self.toUserID = toUserID
        self.status = .pending
    }

    init?(data: [String: Any]) {
        guard let fromUserID = data["fromUserID"] as? String,
              let toUserID = data["toUserID"] as? String,
              let statusString = data["status"] as? String,
              let status = RequestStatus(rawValue: statusString) else {
            return nil
        }
        self.fromUserID = fromUserID
        self.toUserID = toUserID
        self.status = status
        self.id = nil
    }
}
