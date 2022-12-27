//
//  ImagePickerType.swift
//  iOS Example
//
//  Created by Ambu Sangoli on 6/13/18.
//


extension ImagePickerType {
    
    var description: String {
        switch self {
        case .slack:
            return "Slack"
        case .actionSheet:
            return "Action Sheet"
        }
    }
}

