//
//  SignUpViewModel.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/16.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class SignUpViewModel {
    
    enum SignUpStatus {
        case Failed(String)
        case Success
    }
    
    private var repository:Repository
    
    var user:[String:Any] = [:]
    
    init(repository:Repository) {
        self.repository = repository
    }
    
    func register(completion:((SignUpStatus) -> Void)?) {
        self.repository.regiter(user: self.user) { error in
            if error == nil {
                completion?(.Success)
            } else {
                completion?(.Failed(error?.localizedDescription ?? "Login Failed"))
            }
        }
    }
    
    func validate() -> Bool {
        
        return true
    }
}
