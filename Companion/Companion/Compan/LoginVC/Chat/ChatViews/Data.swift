//
//  Data.swift
//  iOS Example
//
//  Created by Ambu Sangoli on 6/13/18.
//

import Foundation

public extension Data {

    static func dataFromJSONFile(_ fileName: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                return data
            } catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
}
