//
//  String+AppConstants.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

extension String {
    /**
     true if self contains characters.
     */
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String {
    
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

    
}
