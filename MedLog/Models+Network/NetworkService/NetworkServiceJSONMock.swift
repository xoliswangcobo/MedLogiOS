//
//  NetworkServiceJSONMock.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class NetworkServiceJSONMock : NetworkServiceProtocol {
    
    var serviceHost: URL = .none
    var authenticationToken: APIAccessToken?
    var refreshTokenHandler: ((APIAccessToken?, ((Error?) -> Void)?) -> Void)?
    var jsonMockAPIBank: [String : Any]?
    
    init() {
        if let filePath = Bundle.main.path(forResource: "medlog_mock_api", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL.init(fileURLWithPath: filePath))
                self.jsonMockAPIBank = (try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]) as [String : Any]
            } catch {
                fatalError("Can not read api mock json file.")
            }
        }
    }
    
    func execute(client: NetworkClientProtocol, responseHandler: @escaping (Error?, Any?) -> Void) {
        
        if client.method() == .GET, let parameters = client.parameters() {
            let url = client.url()
            var urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = Array.init()
            
            for (name, value) in parameters {
                urlComponents?.queryItems?.append(URLQueryItem(name: name, value: value as? String ?? ""))
            }
            
            let mockResponseKey = urlComponents?.url?.absoluteString ?? ""
            
            var successful = false
            if let response = self.jsonMockAPIBank?[mockResponseKey] {
                responseHandler(nil, response)
                successful = true
            } else {
                responseHandler(NSError.init(domain: "HTTPRESPONSEERROR", code: 90001, userInfo: [ NSLocalizedDescriptionKey : "Resource not found" ]), nil)
            }
            print("API Mock: \(!successful ? "Error!." : "") \(url)")
        }
        
    }
    
    func execute<Model : Decodable>(client: NetworkClientProtocol, responseHandler: @escaping (Error?, Model?) -> Void) {
        self.execute(client: client) { (error, response) in
            if let theResponse = response {
                responseHandler(error, Model.decode(theResponse))
            } else {
                responseHandler(error, nil)
            }
        }
    }
}
