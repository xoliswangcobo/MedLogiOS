//
//  LoginViewController.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/14.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Bond
import ReactiveKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var loginButton: TextButton!
    @IBOutlet weak var username: SkyFloatingLabelTextField!
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    
    var loginViewModel:LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = self.loginButton.reactive.controlEvents(.touchUpInside).observeNext { e in
            self.loginViewModel.authenticate() { status in
                switch status {
                    case .Success:
                        let alertController = UIAlertController.init(title: "Login", message: "Login Success", preferredStyle: .alert)
                        alertController.addAction(.init(title: "Dismiss", style: .default))
                        self.present(alertController, animated: true)
                    case .Failed(let message):
                        let alertController = UIAlertController.init(title: "Login", message: message, preferredStyle: .alert)
                        alertController.addAction(.init(title: "Dismiss", style: .default))
                        self.present(alertController, animated: true)
                }
            }
        }
        
        self.loginViewModel.username.bidirectionalBind(to: self.username.reactive.text)
        self.loginViewModel.password.bidirectionalBind(to: self.password.reactive.text)
        
        combineLatest(self.username.reactive.text, self.password.reactive.text) { email, pass in
            return ((email?.count ?? 0) > 0) && ((pass?.count ?? 0) > 0)
        }.bind(to: self.loginButton.reactive.isEnabled)
    }

}
