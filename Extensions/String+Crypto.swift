//
//  String+Crypto.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

extension String {
    
    func isValidBitcoinAddress() -> Bool {
        let fullAddress = self.components(separatedBy: ":")
        
        guard fullAddress.count == 2, fullAddress[0] == "bitcoin" else {
            return false
        }
        
        let r = fullAddress[1]
        let pattern = "^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$"
        
        let bitCoinIDTest = NSPredicate(format:"SELF MATCHES %@", pattern)
        let result = bitCoinIDTest.evaluate(with: r)
        
        return result
    }
}
