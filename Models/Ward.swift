//
//  Ward.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/02.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class Ward: Decodable, Encodable {
    var uuid: String?
    var name: String?
    var location: String?
    var department: Department?
    var hospital: Hospital?
}

extension Ward: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid?.lowercased())
    }
    
    static func == (lhs: Ward, rhs: Ward) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
