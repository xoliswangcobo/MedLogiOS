//
//  ActiveTextField.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

class ActiveTextField: YoshikoTextField {

    @IBInspectable var isPasteEnabled: Bool = true

    @IBInspectable var isSelectEnabled: Bool = true

    @IBInspectable var isSelectAllEnabled: Bool = true

    @IBInspectable var isCopyEnabled: Bool = true

    @IBInspectable var isCutEnabled: Bool = true

    @IBInspectable var isDeleteEnabled: Bool = true
    
    @IBInspectable var isEditingEnabled: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initClass()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initClass()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.initClass()
    }
    
    private func initClass() {
        self.borderStyle = .line
        
        self.placeholder = self.value(forKey: "placeholder") as? String ?? ""
        self.placeholderColor = .placeholder
        self.borderSize = 0
        self.activeBorderColor = .border
        self.font = UIFont(name: "ABeeZee-Regular", size: 17)!
        
        // Using NotificationCenter to avoid using the UITextFieldDelegate incase others need it.
        NotificationCenter.default.addObserver(self, selector: #selector(didBeginEditing(notification:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEndEditing(notification:)), name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextField.textDidChangeNotification, object: nil)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 3
    }
    
    dynamic static var validation: UIKeyboardType? = .default {
        didSet {
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.isEditingEnabled == false {
            self.autocorrectionType = .no
        }
    }
    
    // NotificationCenter
    @objc private func didBeginEditing(notification:Notification) {
        
    }
    
    @objc private func didEndEditing(notification:Notification) {
        self.text = self.text?.trimmingCharacters(in: .whitespaces)
    }
    
    @objc private func textDidChange(notification:Notification) {
        
    }
    
    
    // MARK : ACTIONS
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.isEditingEnabled == false {
            return false
        }
        
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where self.isPasteEnabled == true,
             #selector(UIResponderStandardEditActions.select(_:)) where self.isSelectEnabled == true,
             #selector(UIResponderStandardEditActions.selectAll(_:)) where self.isSelectAllEnabled == true,
             #selector(UIResponderStandardEditActions.copy(_:)) where self.isCopyEnabled == true,
             #selector(UIResponderStandardEditActions.cut(_:)) where self.isCutEnabled == true,
             #selector(UIResponderStandardEditActions.delete(_:)) where self.isDeleteEnabled == true:
            return true
        default:
            return false // Disable all other actions
        }
    }
}
