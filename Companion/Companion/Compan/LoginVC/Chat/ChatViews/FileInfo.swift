//
//  FileInfo.swift
//  iOS Example
//
//  Created by Ambu Sangoli on 6/13/18.
//

import Foundation
import UIKit

enum FileType: Int, Decodable {
    case image = 0
    case attachment
}

struct FileInfo: Decodable {

    let id: String
    let type: FileType
    let originalURL: URL?
    let previewURL: URL?
    let createdAt: Date
    let width: CGFloat
    let height: CGFloat
    let caption: String

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case originalURL = "url"
        case previewURL = "thumb_url"
        case createdAt = "created_at"
        case width
        case height
        case caption
    }
}
