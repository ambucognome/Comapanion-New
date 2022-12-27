//
//  Message.swift
//  iOS Example
//
//  Created by Ambu Sangoli on 6/13/18.
//

import Foundation

enum MessageType: Int, Decodable {
    case text = 0
    case file
}

struct Message: Decodable {

    let id: String!
    let type: MessageType
    var text: String?
    var file: FileInfo?
    let sendByID: Int!
    let createdAt: Date!
    let updatedAt: Date?
    let isIncoming: Bool?
    var isOutgoing: Bool = true

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case text
        case file
        case sendByID = "sender_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isIncoming
    }

    init(id: String, type: MessageType, sendByID: Int, createdAt: Date,isIncoming:Bool) {
        self.id = id
        self.type = type
        self.sendByID = sendByID
        self.createdAt = createdAt
        self.updatedAt = createdAt
        self.isIncoming = isIncoming
    }

    /// Initialize outgoing text message
    init(id: String, sendByID: Int, createdAt: Date, text: String,isIncoming:Bool) {
        self.init(id: id, type: .text, sendByID: sendByID, createdAt: createdAt, isIncoming: isIncoming)
        self.text = text
    }

    /// Initialize outgoing file message
    init(id: String, sendByID: Int, createdAt: Date, file: FileInfo,isIncoming:Bool) {
        self.init(id: id, type: .file, sendByID: sendByID, createdAt: createdAt, isIncoming: isIncoming)
        self.file = file
    }

    func cellIdentifer() -> String {
        switch type {
        case .text:
            return MessageTextCell.reuseIdentifier
        case .file:
            return MessageImageCell.reuseIdentifier
        }
    }
}
