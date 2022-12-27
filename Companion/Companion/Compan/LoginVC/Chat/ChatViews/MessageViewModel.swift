//
//  MessageViewModel.swift
//  Companion
//
//  Created by Ambu Sangoli on 14/11/22.
//

import Foundation
import SwiftyJSON

enum BubbleStyle {
    case facebook
    case instagram

    var description: String {
        switch self {
        case .facebook:
            return "Facebook"
        case .instagram:
            return "Instagram"
        }
    }
}

class MessageViewModel {

    var isRefreshing: Bool = false
    var users: [UserChat] = []
    var messages: [Message] = []
    var currentUser: UserChat?
    var pagination: Pagination?
    var bubbleStyle: BubbleStyle = .facebook

    init(bubbleStyle: BubbleStyle) {
        self.bubbleStyle = bubbleStyle
        currentUser = UserChat(id: 2, name: "Harry Tran", avatarURL: URL(string: "https://i.imgur.com/LIe72Gc.png"))
        getUserData()
    }

    func firstLoadData(completion: @escaping (() -> ())) {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            self?.getDataFromFile(fileName: "conversation") { (messageResponse: [Message], pagi) in
//        self.messages = self.handleDataSource(messages: self.messages)
//                self?.pagination = pagi
//                completion()
//            }
//        }
    }

    func loadMoreData(completion: @escaping ((_ indexPathWillAdds: [IndexPath]) -> ())) {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            self?.getDataFromFile(fileName: "conversation_older") { (messageResponse: [Message], pagi) in
//                let indexPathWillAdds = self!.getIndexPathWillAdds(newDataSize: messageResponse.count)
//                self?.messages.append(contentsOf: self!.handleDataSource(messages: messageResponse).reversed())
//                self?.pagination = pagi
//                completion(indexPathWillAdds)
//            }
//        }
    }

    func getUserData() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.getDataFromFile(fileName: "user") { (userResponse: [UserChat], _) in
                self?.users = userResponse
            }
        }
    }

    private func getDataFromFile<T>(fileName: String, completion: (_ data: [T], _ pagination: Pagination?) -> ()) where T: Decodable {
        guard let jsonData = Data.dataFromJSONFile(fileName) else {
            completion([], nil)
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        guard let listResponse = try? decoder.decode(ListResponseObject<T>.self, from: jsonData) else {
            completion([], nil)
            return
        }
        completion(listResponse.data, listResponse.pagination)
    }
}

extension MessageViewModel {

    func getUserFromID(_ id: Int) -> UserChat {
        let index = users.firstIndex(where: { $0.id == id })
        return users[index!]
    }

    func getPositionInBlockForMessageAtIndex(_ index: Int) -> PositionInBlock {
        let message = messages[index]
        if let beforeItemMessage = messages.item(before: index),
            let afterItemMessage = messages.item(after: index) {
            if beforeItemMessage.isOutgoing == message.isOutgoing
                && message.isOutgoing == afterItemMessage.isOutgoing {
                return .center
            }

            if beforeItemMessage.isOutgoing == message.isOutgoing {
                return .bottom
            }

            if message.isOutgoing == afterItemMessage.isOutgoing {
                return .top
            }

            return .single
        }

        if let beforeItemMessage = messages.item(before: index) {
            if beforeItemMessage.isOutgoing == message.isOutgoing {
                return .bottom
            }
            return .single
        }

        if let afterItemMessage = messages.item(after: index) {
            if afterItemMessage.isOutgoing == message.isOutgoing {
                return .top
            }

            return .single
        }

        return .single
    }

    func handleDataSource(messages: [Message]) -> [Message] {
        let modifiedArray = messages.map { msg -> Message in
            var m = msg
            m.isOutgoing = self.isOutgoingMessage(m)
            return m
        }

        return modifiedArray
    }

    private func isOutgoingMessage(_ message: Message) -> Bool {
        guard let user = currentUser else {
            return false
        }

        return message.sendByID == user.id
    }

    private func getIndexPathWillAdds(newDataSize: Int) -> [IndexPath] {
        let currentNumberMessage = messages.count
        let newNumberMessage = messages.count + newDataSize
        var indexPathWillAdds: [IndexPath] = []
        for index in currentNumberMessage..<newNumberMessage {
            indexPathWillAdds.append(IndexPath(row: index, section: 0))
        }

        return indexPathWillAdds
    }
}

extension DateFormatter {
    
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
