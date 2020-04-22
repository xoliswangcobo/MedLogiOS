//
//  ForgorPasswordViewModel.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/16.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation
import Bond

class ForgorPasswordViewModel {
    
    enum ForgorPasswordStatus {
        case Failed(String)
        case Success
    }
    
    var repository:Repository
    
    var email: Observable<String?> = Observable<String?>("")
    
    init(repository:Repository) {
        self.repository = repository
    }
    
    func sendResetPassword(completion:((ForgorPasswordStatus) -> Void)?) {
        self.repository.resetPasswordSend(email: self.email.value ?? "") { (error) in
            if error == nil {
                completion?(.Success)
            } else {
                completion?(.Failed(error?.localizedDescription ?? "Forgot Password Send Failed"))
            }
        }
    }
    
    func validate() -> Bool {
        guard let email = self.email.value else {
            return false
        }
        
        return email.isValidEmail()
    }
}
