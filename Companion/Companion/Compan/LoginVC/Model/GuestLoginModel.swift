//
//  GuestLoginModel.swift
//  Companion
//
//  Created by Ambu Sangoli on 25/10/23.
//

import Foundation

// MARK: - GuestLoginModel
struct GuestLoginModel: Codable {
    let responseCode: Int
    let responseMessage: String
    let user: GuestUser
}

// MARK: - User
struct GuestUser: Codable {
    let emailID, firstName, lastName, role: String
    let userID, username: String

    enum CodingKeys: String, CodingKey {
        case emailID = "emailId"
        case firstName, lastName, role
        case userID = "userId"
        case username
    }
}
