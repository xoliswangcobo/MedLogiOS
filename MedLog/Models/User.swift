//
//  User.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/02.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class User: Decodable, Encodable {
    var email: String?
    var password: String?
    var firstname: String?
    var lastname: String?
    var mobile: String?
    var uuid: String?
    var countryCode: String?
    var languageCode: String?
    var access:Role?
}

enum Role : String, Codable {
    case ADMIN
    case TECHNICIAN
    case PATIENT
    case ROOT
    case FINANCE
    case PHYSICIAN
    case RECEPTIONIST
    case INTERN_PHYSICIAN
    case DEFAULT
}

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid?.lowercased())
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension User {
    
    func hasUpdate(_ updatedCopy:User) -> Bool {
        if self == updatedCopy {
            var updated = (self.firstname == updatedCopy.firstname)
            updated = updated && (self.lastname == updatedCopy.lastname)
            updated = updated && (self.firstname == updatedCopy.firstname)
            updated = updated && (self.email == updatedCopy.email)
            updated = updated && (self.mobile == updatedCopy.mobile)
            updated = updated && (self.languageCode?.lowercased() == updatedCopy.languageCode?.lowercased())
            updated = updated && (self.countryCode?.lowercased() == updatedCopy.countryCode?.lowercased())
  
            return updated == false
        }
        
        return false
    }
}
