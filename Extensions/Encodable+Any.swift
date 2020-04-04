//
//  Encodable+Any.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

extension Encodable {
    static func encode<T: Encodable>(decoded:T?) -> Any? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .custom({ date, encoder in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = .dateFormat
                var container = encoder.singleValueContainer()
                try container.encode(dateFormatter.string(from: date))
            })
            let encoded = try encoder.encode(decoded)
            return try JSONSerialization.jsonObject(with:encoded, options: [])
        } catch {
            return nil
        }
    }
}
