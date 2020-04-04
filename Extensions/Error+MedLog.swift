//
//  Error+MedLog.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

extension NSError {
    
    static func errorForCode(code:Int) -> NSError {
        var errorDescription = ""
        
        switch code {
            default: errorDescription = "Unknown error occured".localized()
        }
        
        return NSError(domain:"ERROR_\(code)", code:code, userInfo:[NSLocalizedDescriptionKey : errorDescription])
    }
    
    static func errorForMessage(message:String) -> NSError {
        return NSError(domain:"ERROR_XXX", code:0, userInfo:[NSLocalizedDescriptionKey : message.localized()])
    }
}
