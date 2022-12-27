//
//  ChatBarType.swift
//  iOS Example
//
//  Created by Ambu Sangoli on 6/13/18.
//


extension ChatBarStyle {
    
    var description: String {
        switch self {
        case .default:
            return "Default"
        case .slack:
            return "Slack"
        default:
            return ""
        }
    }
}
