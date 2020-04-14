//
//  APIServiceCORERequest.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class APIServiceCORERequest : APIServiceProtocol {
    
    var serviceHost: URL
    var authenticationToken: APIAccessToken?
    var refreshTokenHandler: ((APIAccessToken?, ((Error?) -> Void)?) -> Void)?
    
    private var isRefreshingToken = false
    
    init(serviceHost: URL, authenticationToken: APIAccessToken? = nil, tokenRefreshHandler: ((APIAccessToken?, ((Error?) -> Void)?) -> Void)? = nil) {
        self.serviceHost = serviceHost
        self.authenticationToken = authenticationToken
        self.refreshTokenHandler = tokenRefreshHandler
    }
    
    private (set) static var sharedService: APIServiceCORERequest = APIServiceCORERequest(serviceHost: .baseURL)
    
    static func configureSharedService(serviceHost: URL, authenticationToken: APIAccessToken? = nil, tokenRefreshHandler: ((APIAccessToken?, ((Error?) -> Void)?) -> Void)? = nil) -> Void {
        sharedService.serviceHost = serviceHost
        sharedService.authenticationToken = authenticationToken
        sharedService.refreshTokenHandler = tokenRefreshHandler
    }
    
    func execute<Model : Decodable>(apiClient: APIClientProtocol, responseHandler: @escaping (Error?, Model?) -> Void) {
        self.execute(apiClient: apiClient) { (error, response) in
            if let theResponse = response {
                let apiResponse:APIResponse<Model>? = Model.decode(theResponse)
                
                if apiResponse?.success == true {
                    responseHandler(nil, Model.decode(theResponse))
                } else if apiResponse?.success == false {
                    if let code =  apiResponse?.code, code > 0 {
                        responseHandler(NSError.errorForCode(code: code), nil)
                    } else if let message = apiResponse?.message, message != "" {
                        responseHandler(NSError.errorForMessage(message: message), nil)
                    } else {
                        responseHandler(NSError.errorForCode(code: 0), nil)
                    }
                } else {
                    responseHandler(error, Model.decode(theResponse))
                }
            } else {
                responseHandler(error, nil)
            }
        }
    }
    
    func execute(apiClient: APIClientProtocol, responseHandler: @escaping (Error?, Any?) -> Void) {
        
        guard let httpMethod: HTTPRequestMethod = HTTPRequestMethod(rawValue: apiClient.method().rawValue) else  {
            return
        }
        
        var httpHeaders: [String : String] = apiClient.extraHeaders() ?? [:]
        
        httpHeaders["Accept"] = apiClient.acceptType().rawValue
    
        if let accessToken = self.authenticationToken {
            if let accessTokenValue = accessToken.accessToken {
                httpHeaders["Authorization"] = String(format: "%@ %@", accessToken.tokenType, accessTokenValue)
            }
        }
        
        let parameterEncoding = apiClient.encoding()
        
        let responseProcessor = { (data: Data?, response: URLResponse?, error: Error?) in
            if let theResponseData = data {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: theResponseData, options: [])
                    print("APICore Response: \(String(format: "%@%@ -: %@", self.serviceHost.absoluteString, apiClient.url().absoluteString, (responseObject as? [String : Any])?.jsonString() ?? ""))")
                    
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
            print("APICoreRequest: \(String(format: "%@%@ -: %@", self.serviceHost.absoluteString, apiClient.url().absoluteString, apiClient.parameters()?.jsonString() ?? ""))")
            
            // Need to store dataTask while token in some state
            let _ = APICoreRequest.request(host: self.serviceHost)
                .setPath(apiClient.url())
                .setHttpMethod(httpMethod)
                .setHttpEncoding(parameterEncoding)
                .setParameters(apiClient.parameters())
                .setHTTPHeaders(httpHeaders)
                .execute() { data, response, error in
                    responseProcessor(data, response, error)
            }
        }
        
        // Evaluate Access Token
        if (self.authenticationToken != nil) {
            if (self.authenticationToken?.tokenStatus() != .valid) {
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
