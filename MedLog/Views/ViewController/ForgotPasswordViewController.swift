//
//  ForgotPasswordViewController.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/14.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Bond
import ReactiveKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var sendForgotPasswordButton: TextButton!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    
    var viewModel:ForgorPasswordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBinding()
    }
    
    private func setUpBinding() {
        self.viewModel.email.bidirectionalBind(to: self.email.reactive.text)
        
        let _ = self.email.reactive.text.observeNext { text in
            self.sendForgotPasswordButton.isEnabled = self.viewModel.validate()
        }
        
        let _ = self.sendForgotPasswordButton.reactive.controlEvents(.touchUpInside).observeNext { e in
            self.forgotPasswordSend()
        }
    }
    
    
    @IBAction func forgotPasswordSend() {
        self.viewModel.sendResetPassword { (status) in
            switch status {
                case .Success:
                    let alertController = UIAlertController.init(title: "Reset Password", message: "Email Sent Successfully", preferredStyle: .alert)
                    alertController.addAction(.init(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true)
                case .Failed(let message):
                    let alertController = UIAlertController.init(title: "Reset Password", message: message, preferredStyle: .alert)
                    alertController.addAction(.init(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true)
            }
        }
    }
}
