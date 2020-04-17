//
//  ServiceHTTPAPIRequest.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class ServiceHTTPAPIRequest : NetworkServiceProtocol {
    
    var serviceHost: URL
    var authenticationToken: APIAccessToken?
    var refreshTokenHandler: ((APIAccessToken?, ((Error?) -> Void)?) -> Void)?
    
    private var isRefreshingToken = false
    
    init(serviceHost: URL, authenticationToken: APIAccessToken? = nil, tokenRefreshHandler: ((APIAccessToken?, ((Error?) -> Void)?) -> Void)? = nil) {
        self.serviceHost = serviceHost
        self.authenticationToken = authenticationToken
        self.refreshTokenHandler = tokenRefreshHandler
    }
    
    func execute<Model : Decodable>(client: NetworkClientProtocol, responseHandler: @escaping (Error?, Model?) -> Void) {
        self.execute(client: client) { (error, response) in
            if let theResponse = response {
                let apiResponse:APIClientResponse? = APIClientResponse.decode(theResponse)
                let model:Model? = Model.decode(apiResponse?.data)
                
                switch apiResponse?.status {
                    case .Success:
                        responseHandler(nil, model)
                    case .Failed(let message):
                        if let code =  apiResponse?.code, code > 0 {
                            responseHandler(NSError.errorForCode(code: code), nil)
                        } else if message.isNotEmpty {
                            responseHandler(NSError.errorForMessage(message: message), nil)
                        } else {
                            responseHandler(NSError.errorForCode(code: 0), nil)
                        }
                    default:
                        responseHandler(error, Model.decode(theResponse))
                }
            } else {
                responseHandler(error, nil)
            }
        }
    }
    
    func execute(client: NetworkClientProtocol, responseHandler: @escaping (Error?, Any?) -> Void) {
        
        guard let httpMethod: HTTPRequestMethod = HTTPRequestMethod(rawValue: client.method().rawValue) else  {
            return
        }
        
        var httpHeaders: [String : String] = client.extraHeaders() ?? [:]
        
        httpHeaders["Accept"] = client.acceptType().rawValue
    
        if let accessToken = self.authenticationToken {
            if let accessTokenValue = accessToken.accessToken {
                httpHeaders["Authorization"] = String(format: "%@ %@", accessToken.tokenType, accessTokenValue)
            }
        }
        
        let parameterEncoding = client.encoding()
        
        let responseProcessor = { (data: Data?, response: URLResponse?, error: Error?) in
            if let theResponseData = data {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: theResponseData, options: [])
                    print("APICore Response: \(String(format: "%@%@ -: %@", self.serviceHost.absoluteString, client.url().absoluteString, (responseObject as? [String : Any])?.jsonString() ?? ""))")
                    
                    if error != nil {
                        responseHandler(error, responseObject)
                    } else {
                        responseHandler(nil, responseObject)
                    }
                } catch let tryError {
                    responseHandler(tryError, nil)
                }
            } else {
                responseHandler(error, nil)
            }
        }
        
        let continueExecute:(() -> Void) = {
            print("APICoreRequest: \(String(format: "%@%@ -: %@", self.serviceHost.absoluteString, client.url().absoluteString, client.parameters()?.jsonString() ?? ""))")
            
            // Need to store dataTask while token in some state
            let _ = HTTPAPIRequest.request(host: self.serviceHost)
                .setPath(client.url())
                .setHttpMethod(httpMethod)
                .setHttpEncoding(parameterEncoding)
                .setParameters(client.parameters())
                .setHTTPHeaders(httpHeaders)
                .execute() { data, response, error in
                    responseProcessor(data, response, error)
            }
        }
        
        // Evaluate Access Token
        if (self.authenticationToken != nil) {
            if (self.authenticationToken?.tokenStatus() != .valid) {
                if self.refreshTokenHandler == nil {
                    responseHandler(NSError.errorForMessage(message: "Session Expired".localized()), nil)
                    return
                }
                
                self.refreshTokenHandler?(self.authenticationToken, { error in
                    if self.authenticationToken?.tokenStatus() != .expired {
                        continueExecute()
                    } else {
                        responseHandler(NSError.errorForMessage(message: "Session Expired".localized()), nil)
                    }
                })
                return
            }
        }
        
        continueExecute()
    }
    
}
