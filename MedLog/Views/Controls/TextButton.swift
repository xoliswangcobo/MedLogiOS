//
//  TextButton.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

class TextButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .primary
        self.layer.cornerRadius = 5
    }
    
    override open var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled == true ? .primary : .lightGray
        }
    }
}
