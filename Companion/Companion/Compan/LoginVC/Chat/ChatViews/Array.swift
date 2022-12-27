//
//  Array.swift
//  iOS Example
//
//  Created by Ambu Sangoli on 6/13/18.
//

import Foundation

extension Array {

    func item(before index: Int) -> Element? {
        if index < 1 {
            return nil
        }

        if index > count {
            return nil
        }

        return self[index - 1]
    }

    func item(after index: Int) -> Element? {
        if index < -1 {
            return nil
        }

        if index <= count - 2 {
            return self[index + 1]
        }

        return nil
    }
}
