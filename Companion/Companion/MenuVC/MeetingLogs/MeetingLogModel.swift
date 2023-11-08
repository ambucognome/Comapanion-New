//
//  MeetingLogModel.swift
//  Companion
//
//  Created by Ambu Sangoli on 08/11/23.
//

import Foundation

// MARK: - MeetingLogModel
struct MeetingLogModel: Codable {
    let mei, domain, concept, sourceURI: String
    let parentID, eventID, metadata, eventTime: String
    let booleanValue: Bool
    let status, startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case mei, domain, concept
        case sourceURI = "sourceUri"
        case parentID = "parentId"
        case eventID = "eventId"
        case metadata, eventTime, booleanValue, status, startTime, endTime
    }
}
