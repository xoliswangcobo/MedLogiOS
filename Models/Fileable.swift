//
//  Fileable.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/02.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class Fileable: Decodable, Encodable {
    var content:Data?
    var contentType:FileContentType = .RAWDATA
    var timestamp:Date?
    var reminder:Reminder = .NEVER
    
}

enum FileContentType: String, Decodable, Encodable {
    case PDF
    case LINK
    case PHOTO
    case XRAY
    case TEXT
    case RAWDATA
    case EXCELL
    case EVENT
    case NOTE
}

enum Reminder: Int, Decodable, Encodable {
    case HALFHOURLY
    case HOURLY
    case DAILY
    case WEEKLY
    case NEVER
    
    func interval() -> Int {
        switch self {
            case .HALFHOURLY:
                return 30
            case .HOURLY:
                return 60
            case .DAILY:
                return 1440
            case .WEEKLY:
                return 10080
            default:
                return -1
        }
    }
}
