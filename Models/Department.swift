//
//  Department.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/02.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class Department: Decodable, Encodable {
    var uuid: String?
    var name: String?
    var location: String?
    var hospital: Hospital?
}

extension Department: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid?.lowercased())
    }
    
    static func == (lhs: Department, rhs: Department) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
