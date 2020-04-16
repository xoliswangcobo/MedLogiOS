//
//  NetworkServiceProtocol.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    
    var serviceHost: URL { get set }
    var authenticationToken: APIAccessToken? { get set }
    var refreshTokenHandler: ((APIAccessToken?, ((Error?) -> Void)?) -> Void)? { get set }
    
    func execute(client: NetworkClientProtocol, responseHandler: @escaping (Error?, Any?) -> Void)
    func execute<Model : Decodable>(client: NetworkClientProtocol, responseHandler: @escaping (Error?, Model?) -> Void)
    
}
