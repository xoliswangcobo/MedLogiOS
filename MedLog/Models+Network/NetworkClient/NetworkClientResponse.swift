//
//  APIClientResponse.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class APIClientResponse : Decodable {
    
    enum ResponseStatus {
        case Failed(String)
        case Success(String)
    }
    
    private enum CodingKeys: String, CodingKey {
        case success
        case message
        case code
        case data
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let message = try? values.decode(String.self, forKey: .message)
        let succeeded = try? values.decode(Bool.self, forKey: .success)
        self.status = succeeded == true ? .Success(message ?? "") : .Failed(message ?? "")
        
        self.code = try? values.decode(Int.self, forKey: .code)
        self.data = try? values.decode([String:Any].self, forKey: .data)
    }
    
    var status: ResponseStatus?
    var code: Int?
    var data: [String:Any]?
}
