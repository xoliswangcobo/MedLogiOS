//
//  File.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/02.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class File: Decodable, Encodable {
    var uuid: String?
    var fileables:[Fileable] = []
    var patient: Patient?
    var status: FileStatus?
    var users: [User] = []
    var creator: User?
    var created: Date?
    var modified: Date?
}

enum FileStatus: String, Decodable, Encodable {
    case ACTIVE
    case DELETED
    case CLASSIFIED
    case ARCHIVED
}
