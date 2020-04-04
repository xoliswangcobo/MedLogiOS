//
//  APIServiceProtocol.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    
    var serviceHost: URL { get set }
    var authenticationToken: APIAccessToken? { get set }
    var refreshTokenHandler: ((APIAccessToken?, ((Error?) -> Void)?) -> Void)? { get set }
    
    func execute(apiClient: APIClientProtocol, responseHandler: @escaping (Error?, Any?) -> Void)
    func execute<Model : Decodable>(apiClient: APIClientProtocol, responseHandler: @escaping (Error?, Model?) -> Void)
    
}
