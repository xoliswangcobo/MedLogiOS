//
//  SignUpViewModel.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/16.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

struct UserDetails: Encodable {
    var email: String?
    var password: String?
    var firstname: String?
    var lastname: String?
    var mobile: String?
    var country: String?
    var language: String?
}

class SignUpViewModel {
    
    enum SignUpStatus {
        case Failed(String)
        case Success
    }
    
    var repository:Repository
    
    var user = UserDetails()
    var languages:[(code:String, name:String)] = [(name:"South Africa", code:"ZA")]
    var countries:[(code:String, name:String)] = [(name:"English", code:"en"), (name:"IsiZulu", code:"zu")]
    
    init(repository:Repository) {
        self.repository = repository
    }
    
    func register(completion:((SignUpStatus) -> Void)?) {
        guard let details = UserDetails.encode(decoded: self.user) as? [String : Any] else {
            completion?(.Failed("Sign up failed"))
            return
        }
        
        self.repository.regiter(user: details) { error in
            if error == nil {
                completion?(.Success)
            } else {
                completion?(.Failed(error?.localizedDescription ?? "Login Failed"))
            }
        }
    }
    
    func validate() -> Bool {
        guard let email = self.user.email, let password = self.user.password, let firstname = self.user.firstname, let lastname = self.user.lastname, let mobile = self.user.mobile else {
            return false
        }
        
        if let country = self.user.country {
            self.user.country = self.countries.filter({ $0.name == country}).first?.code
        }
        
        if let language = self.user.language {
            self.user.language = self.languages.filter({ $0.name == language}).first?.code
        }
        
        return email.isNotEmpty && password.isNotEmpty && firstname.isNotEmpty && lastname.isNotEmpty && mobile.isNotEmpty
    }
}
