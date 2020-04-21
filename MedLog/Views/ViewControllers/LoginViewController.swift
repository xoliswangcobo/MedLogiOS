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
    
    var viewModel:LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBinding()
    }

    private func setUpBinding() {
        self.viewModel.username.bidirectionalBind(to: self.username.reactive.text)
        self.viewModel.password.bidirectionalBind(to: self.password.reactive.text)
        
        combineLatest(self.username.reactive.text, self.password.reactive.text) { email, pass in
            return self.viewModel.validate()
        }.bind(to: self.loginButton.reactive.isEnabled)
        
        let _ = self.password.reactive.controlEvents([.editingDidEnd, .editingDidBegin]).observeNext {
            self.password.errorMessage = ((self.password.text?.count ?? 0 > 0) && (self.password.text?.isPassword() == false)) ? "Password should be one upper and lower case letter, one number, one special character, minimum 8 characters and maximum 10 characters." : ""
        }
        
        let _ = self.username.reactive.controlEvents([.editingDidEnd, .editingDidBegin]).observeNext {
            self.username.errorMessage = ((self.username.text?.count ?? 0 > 0) && (self.username.text?.isValidEmail() == false)) ? "Not a valid email address." : ""
        }
        
        let _ = self.password.reactive.controlEvents(.editingChanged).observeNext {
            self.password.errorMessage = ""
        }
        
        let _ = self.username.reactive.controlEvents(.editingChanged).observeNext {
            self.username.errorMessage = ""
        }
        
        let _ = self.loginButton.reactive.controlEvents(.touchUpInside).observeNext {
            self.authenticate()
        }
    }
    
    @IBAction func authenticate() {
        self.viewModel.authenticate() { status in
            switch status {
                case .Success:
                    let navigationController = Storyboard.App.instantiateViewController(viewControllerClass: UINavigationController.self, storyboardID: "AppNavigationController")
                    let tabBarController = navigationController.viewControllers.first as! AppTabBarController
                    tabBarController.repository = self.viewModel.repository
                    UIApplication.setRootView(navigationController, options: .transitionCrossDissolve)
                case .Failed(let message):
                    let alertController = UIAlertController.init(title: "Login", message: message, preferredStyle: .alert)
                    alertController.addAction(.init(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp" {
            let registrationController = segue.destination as! RegisterViewController
            registrationController.viewModel = .init(repository: self.viewModel.repository)
        } else if segue.identifier == "toForgotPassword" {
            let forgotPasswordController = segue.destination as! ForgotPasswordViewController
            forgotPasswordController.viewModel = .init(repository: self.viewModel.repository)
        }
    }
}
