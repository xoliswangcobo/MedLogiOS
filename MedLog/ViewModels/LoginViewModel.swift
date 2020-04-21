//
//  LoginViewModel.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/15.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation
import Bond

class LoginViewModel {
    
    enum LoginStatus {
        case Failed(String)
        case Success
    }
    
    var repository:Repository
    
    var username: Observable<String?> = Observable<String?>("")
    var password: Observable<String?> = Observable<String?>("")
    
    init(repository:Repository) {
        self.repository = repository
    }
    
    func authenticate(completion:((LoginStatus) -> Void)?) {
        self.repository.authenticate(email: self.username.value ?? "", password: self.password.value ?? "") { (apitoken, error) in
            self.repository.servive.authenticationToken = apitoken
            
            if error == nil {
                completion?(.Success)
            } else {
                completion?(.Failed(error?.localizedDescription ?? "Login Failed"))
            }
        }
    }
    
    func validate() -> Bool {
        guard let username = self.username.value, let password = self.password.value else {
            return false
        }
        
        return username.isValidEmail() && password.isPassword()
    }
}
