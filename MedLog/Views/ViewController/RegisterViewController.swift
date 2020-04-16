//
//  RegisterViewController.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/14.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Bond
import ReactiveKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var registerButton: TextButton!
    @IBOutlet weak var username: SkyFloatingLabelTextField!
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    @IBOutlet weak var firtname: SkyFloatingLabelTextField!
    @IBOutlet weak var lastname: SkyFloatingLabelTextField!
    @IBOutlet weak var mobile: SkyFloatingLabelTextField!
    @IBOutlet weak var country: SkyFloatingLabelTextField!
    @IBOutlet weak var language: SkyFloatingLabelTextField!
    
    var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpBinding()
    }
    
    func setUpBinding() {
        combineLatest(self.username.reactive.text, self.password.reactive.text, self.firtname.reactive.text, self.lastname.reactive.text) { email, pass, firstname, lastname in
            self.viewModel.user.email = email
            self.viewModel.user.password = pass
            self.viewModel.user.firstname = firstname
            self.viewModel.user.lastname = lastname
            return self.viewModel.validate()
        }.bind(to: self.registerButton.reactive.isEnabled)
        
        combineLatest(self.mobile.reactive.text, self.country.reactive.text, self.language.reactive.text) { mobile, country, language in
            self.viewModel.user.mobile = mobile
            self.viewModel.user.country = country
            self.viewModel.user.language = language
            return self.viewModel.validate()
        }.bind(to: self.registerButton.reactive.isEnabled)
        
        let _ = self.registerButton.reactive.controlEvents(.touchUpInside).observeNext { e in
            self.viewModel.register { status in
                switch status {
                    case .Success:
                        let alertController = UIAlertController.init(title: "Sign Up", message: "Registration Success", preferredStyle: .alert)
                        alertController.addAction(.init(title: "Dismiss", style: .default))
                        self.present(alertController, animated: true)
                    case .Failed(let message):
                        let alertController = UIAlertController.init(title: "Sign Up", message: message, preferredStyle: .alert)
                        alertController.addAction(.init(title: "Dismiss", style: .default))
                        self.present(alertController, animated: true)
                }
            }
        }
    }
}
