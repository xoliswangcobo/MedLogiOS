//
//  Hospital.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/02.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

enum HospitalType : String, Codable {
    case PUBLIC
    case PRIVATE
    case PRIVATE_CLASSIFIED
    case UNSPECIFIED
}

class Hospital: Decodable, Encodable {
    var name: String?
    var region: String?
    var location: String?
    var uuid: String?
    var type: HospitalType
}

extension Hospital: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid?.lowercased())
    }
    
    static func == (lhs: Hospital, rhs: Hospital) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
