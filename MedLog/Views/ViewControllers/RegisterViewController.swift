//
//  RegisterViewController.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/14.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class RegisterViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var registerButton: TextButton!
    @IBOutlet weak var username: SkyFloatingLabelTextField!
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    @IBOutlet weak var firtname: SkyFloatingLabelTextField!
    @IBOutlet weak var lastname: SkyFloatingLabelTextField!
    @IBOutlet weak var mobile: SkyFloatingLabelTextField!
    @IBOutlet weak var country: SkyFloatingLabelTextField!
    @IBOutlet weak var language: SkyFloatingLabelTextField!
    
    var countrySelect: UIPickerView!
    var languageSelect: UIPickerView!
    
    var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPickerViews()
        self.setUpBinding()
    }
    
    private func setUpPickerViews() {
        self.countrySelect = .init()
        self.countrySelect.delegate = self
        self.country.inputView = self.countrySelect
        
        self.languageSelect = .init()
        self.languageSelect.delegate = self
        self.language.inputView = self.languageSelect
    }
    
    private func setUpBinding() {
        self.viewModel.email.bidirectionalBind(to: self.username.reactive.text)
        self.viewModel.password.bidirectionalBind(to: self.password.reactive.text)
        self.viewModel.firstname.bidirectionalBind(to: self.firtname.reactive.text)
        self.viewModel.lastname.bidirectionalBind(to: self.lastname.reactive.text)
        self.viewModel.mobile.bidirectionalBind(to: self.mobile.reactive.text)
        self.viewModel.language.bidirectionalBind(to: self.language.reactive.text)
        self.viewModel.country.bidirectionalBind(to: self.country.reactive.text)
        
        
        // UIPicker Validation Prepare
        
        let _ = self.viewModel.availableCountries.observeNext { _ in 
            self.countrySelect.reloadAllComponents()
            self.country.isEnabled = self.viewModel.countries.count > 0
            self.country.placeholder = self.country.isEnabled ? "select country" : "no countries available"
        }
        
        let _ = self.viewModel.availableLanguages.observeNext { _ in
            self.languageSelect.reloadAllComponents()
            self.language.isEnabled = self.viewModel.languages.count > 0
            self.language.placeholder = self.language.isEnabled ? "select language" : "no languages available"
        }
        
        // Username and Password
        
        let _ = self.password.reactive.controlEvents([.editingDidEnd, .editingDidBegin]).observeNext {
            self.password.errorMessage = ((self.password.text?.count ?? 0 > 0) && (self.password.text?.isPassword() == false)) ? "Password should be one upper and lower case letter, one number, one special character, minimum 8 characters and maximum 10 characters" : ""
        }
        
        let _ = self.username.reactive.controlEvents([.editingDidEnd, .editingDidBegin]).observeNext {
            self.username.errorMessage = ((self.username.text?.count ?? 0 > 0) && (self.username.text?.isValidEmail() == false)) ? "Not a valid email address" : ""
        }
        
        let _ = self.password.reactive.controlEvents(.editingChanged).observeNext {
            self.password.errorMessage = ""
        }
        
        let _ = self.username.reactive.controlEvents(.editingChanged).observeNext {
            self.username.errorMessage = ""
        }
        
        // Other Required
        
        let _ = self.firtname.reactive.controlEvents([.editingDidEnd, .editingDidBegin]).observeNext {
            self.firtname.errorMessage = (self.firtname.text?.count ?? 0 > 0) ? "" : "Firstname required"
        }
        
        let _ = self.lastname.reactive.controlEvents([.editingDidEnd, .editingDidBegin]).observeNext {
            self.lastname.errorMessage = (self.lastname.text?.count ?? 0 > 0) ? "" : "Lastname required"
        }
        
        let _ = self.mobile.reactive.controlEvents([.editingDidEnd, .editingDidBegin]).observeNext {
            self.mobile.errorMessage = (self.mobile.text?.count ?? 0 > 0) ? "" : "Mobile number required"
        }
        
        let _ = self.firtname.reactive.controlEvents(.editingChanged).observeNext {
            self.firtname.errorMessage = ""
        }
        
        let _ = self.lastname.reactive.controlEvents(.editingChanged).observeNext {
            self.lastname.errorMessage = ""
        }
        
        let _ = self.mobile.reactive.controlEvents(.editingChanged).observeNext {
            self.mobile.errorMessage = ""
        }
        
        // Global Validation
        
        combineLatest(self.username.reactive.text, self.password.reactive.text, self.firtname.reactive.text, self.lastname.reactive.text) { email, pass, firstname, lastname in
            return self.viewModel.validate()
        }.bind(to: self.registerButton.reactive.isEnabled)
        
        combineLatest(self.mobile.reactive.text, self.country.reactive.text, self.language.reactive.text) { mobile, country, language in
            return self.viewModel.validate()
        }.bind(to: self.registerButton.reactive.isEnabled)
        
        let _ = self.registerButton.reactive.controlEvents(.touchUpInside).observeNext {
            self.register()
        }
    }
    
    @IBAction func register() {
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

    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.countrySelect {
            return self.viewModel.countries.count
        } else if pickerView == self.languageSelect {
            return self.viewModel.languages.count
        }
        
        return 0
    }

    // MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if pickerView == self.countrySelect {
            let country = String(format:"%@ - %@", String.emojiFlag(regionCode: self.viewModel.countries[row].code) ?? "", self.viewModel.countries[row].name)
            return .init(string: country, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkText, NSAttributedString.Key.font: UIFont.medium])
        } else if pickerView == self.languageSelect {
            let language = String(format:"%@", self.viewModel.languages[row].name)
            return .init(string: language, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkText, NSAttributedString.Key.font: UIFont.medium])
        }
        
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.countrySelect {
            self.country.text = self.viewModel.countries[row].name
        } else if pickerView == self.languageSelect {
            self.language.text = self.viewModel.languages[row].name
        }
    }
}
