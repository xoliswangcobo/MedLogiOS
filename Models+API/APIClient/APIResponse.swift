//
//  APIResponse.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class APIResponse<Model:Decodable> : Decodable {
    var result: Bool?
    var message: String?
    var code: Int?
    var data: Model?
}
