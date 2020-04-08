//
//  Decodable+Any.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

private protocol JSONSerializableCollection {
    func jsonString() -> String?
}

extension JSONSerializableCollection {
    func jsonString() -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
        guard jsonData != nil else {return nil}
        let jsonString = String(data: jsonData!, encoding: .utf8)
        guard jsonString != nil else {return nil}
        return jsonString!
    }
}

extension Array: JSONSerializableCollection { }

extension Dictionary: JSONSerializableCollection { }

extension NSDictionary: JSONSerializableCollection { }

extension NSArray: JSONSerializableCollection { }

extension Decodable {
    static func decode<T: Decodable>(_ jsonCollection:Any?) -> T? {
        if let theData = jsonCollection as? JSONSerializableCollection {
            do {
                if let theJSONData = theData.jsonString()?.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .custom({ decoder -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = .dateFormat
                        return dateFormatter.date(from: dateString) ?? Date()
                    })
                    let model = try decoder.decode(T.self, from:theJSONData)
                    return model
                } else {
                    return nil
                }
            } catch let error {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
}
