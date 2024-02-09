//
//  CallLogModel.swift
//  Companion
//
//  Created by Ambu Sangoli on 01/11/23.
//

import Foundation

// MARK: - CallLogModel
struct CallLogModel: Codable {
    var outgoing, incoming, missed, rejected: [Log]
}

// MARK: - Incoming
struct Log: Codable {
    var roomID, caller, callerEmail, callee: String?
    var calleeEmail, type: String?
    var duration: Int
    var startTime, endTime: String
    var reasonForCall: String
    var transcriptExists: Bool
    var transcript, formattedTranscription: String?

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case caller, callerEmail, callee, calleeEmail, type, duration, startTime, endTime, reasonForCall, transcriptExists, transcript, formattedTranscription
    }
}
