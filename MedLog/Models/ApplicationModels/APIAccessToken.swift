//
//  APIAccessToken.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class APIAccessToken : Codable {
    
    enum TokenStatus: String {
        case valid
        case expired
        case expiring
    }
    
    fileprivate enum CodingKeys : String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
    
    var accessToken: String?
    var tokenType: String!
    var expiresIn: Date?
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken) ?? ""
        self.tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType) ?? "Bearer"
        self.expiresIn = Date().addSec(n: try values.decodeIfPresent(Int.self, forKey: .expiresIn) ?? 0)
    }
    
    func tokenStatus() -> TokenStatus {
        let remainingTime =  (self.expiresIn?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
        
        if (remainingTime >= Timer.accessTokenRefreshInterval) {
            return .valid
        } else if (remainingTime < Timer.accessTokenRefreshInterval) && (remainingTime > 0) {
            return .expiring
        }
        
        return .expired
    }
    
    func save(encryptionKey:String) -> Bool {
        let tokenData = (APIAccessToken.encode(decoded:self) as? [String:Any])?.jsonString()?.data(using:.utf8)
        
        if let data = tokenData {
            UserDefaults.standard.set(data.encrypt(key: encryptionKey), forKey: "api_access")
            return UserDefaults.standard.synchronize()
        }
        
        return false
    }
    
    class func reload(decryptionKey:String) -> APIAccessToken? {
        let data = UserDefaults.standard.data(forKey: "api_access")
        
        guard let jsonData = data?.decrypt(key: decryptionKey) else {
            UserDefaults.standard.removeObject(forKey: "api_access")
            UserDefaults.standard.synchronize()
            return nil
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            UserDefaults.standard.removeObject(forKey: "api_access")
            UserDefaults.standard.synchronize()
            return nil
        }
        
        return APIAccessToken.decode((Dictionary(string: jsonString) as [String:Any]) as Any?)
    }
}
