//
//  UITextField+Password.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

extension UITextField {
    
    func configureForShowHidePasswordButton() {
        let size = self.frame.height * 0.7
        // Work-around for iOS 13 disregarding rightView's frame
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalToConstant: size + 8).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: size).isActive = true
        let showHidePasswordButton = UIButton(type: .custom)
        showHidePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(showHidePasswordButton)
        showHidePasswordButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        showHidePasswordButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        showHidePasswordButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        showHidePasswordButton.setImage(UIImage(named: "eye"), for: .normal)
        showHidePasswordButton.addAction(controlEvents: .touchUpInside, ForAction: {
            self.isSecureTextEntry.toggle()
            // Work-around for unintended side-effect of text clearing after toggling 'isSecureTextEntry'
            if let originalInput = self.text {
                self.text = nil
                self.insertText(originalInput)
            }
        })
        self.rightView = containerView
        self.rightViewMode = .always
    }
    
}
