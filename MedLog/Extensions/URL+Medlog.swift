//
//  URL+MedLog.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

extension URL {
    
    static let liveBaseURL = URL(string: "http://127.0.0.1:8888/medlog/public")!
    
    static let liveAuthURL = URL(string: "http://127.0.0.1:8888/medlog/public")!
    
    static let baseURL:URL = URL(string: "http://127.0.0.1:8888/medlog/public")!
    
    static let authURL:URL = URL(string: "http://127.0.0.1:8888/medlog/public")!
    
    static let terms:URL = URL(string: "".localized())!
    
    static let privacyPolicy:URL = URL(string: "".localized())!
    
    static let website:URL = URL(string: "".localized())!
    
    static let support:URL = URL(string: "".localized())!
    
    static let none: URL = URL(string: "/")!
}
