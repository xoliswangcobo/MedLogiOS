//
//  SignUpViewModel.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/16.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation
import Bond

class SignUpViewModel {
    
    enum SignUpStatus {
        case Failed(String)
        case Success
    }
    
    var repository:Repository
    
    var countries:[(code:String, name:String)] = [(name:"South Africa", code:"ZA")]
    var languages:[(code:String, name:String)] = [(name:"English", code:"en"), (name:"IsiZulu", code:"zu")]
    
    var email: Observable<String?> = Observable<String?>("ngcobox@gmail.com")
    var password: Observable<String?> = Observable<String?>("12345")
    var firstname: Observable<String?> = Observable<String?>("Xoliswa")
    var lastname: Observable<String?> = Observable<String?>("Ngcobo")
    var mobile: Observable<String?> = Observable<String?>("+27833374192")
    var country: Observable<String?> = Observable<String?>("South Africa")
    var language: Observable<String?> = Observable<String?>("English")
    
    init(repository:Repository) {
        self.repository = repository
    }
    
    func register(completion:((SignUpStatus) -> Void)?) {
        let details:[String:Any] = [
            "email" : self.email.value as Any,
            "password" : self.password.value as Any,
            "firstname" : self.firstname.value as Any,
            "lastname" : self.lastname.value as Any,
            "mobile" : self.mobile.value as Any,
            "country_code" : self.countries.filter({ $0.name == self.country.value }).first?.code as Any,
            "language_code" : self.languages.filter({ $0.name == self.language.value }).first?.code as Any
        ]
        
        self.repository.regiter(user: details) { error in
            if error == nil {
                completion?(.Success)
            } else {
                completion?(.Failed(error?.localizedDescription ?? "Login Failed"))
            }
        }
    }
    
    func validate() -> Bool {
        guard let email = self.email.value, let password = self.password.value, let firstname = self.firstname.value, let lastname = self.lastname.value, let mobile = self.mobile.value, let language = self.language.value, let country = self.country.value else {
            return false
        }

        return (email.isNotEmpty && password.isNotEmpty && firstname.isNotEmpty && lastname.isNotEmpty && mobile.isNotEmpty && country.isNotEmpty && language.isNotEmpty)
    }
}
