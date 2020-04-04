//
//  String+CountryFlag.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//
// https://github.com/bendodson/flag-emoji-from-country-code/blob/master/FlagPlayground.playground/Contents.swift

import Foundation

extension String {
    static func emojiFlag(regionCode: String) -> String? {
        let code = regionCode.uppercased()
        
        guard Locale.isoRegionCodes.contains(code) else {
            return nil
        }
        
        var flagString = ""
        for s in code.unicodeScalars {
            guard let scalar = UnicodeScalar(127397 + s.value) else {
                continue
            }
            
            flagString.append(String(scalar))
        }
        
        return flagString
    }
}
