//
//  HTTPAPIRequest.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//
//  Using a BuilderPattern
//  This is not ready for big uploads

import Foundation


class HTTPAPIRequest {
    
    private var host: URL
    private var path: URL = .none
    private var headers: [String: String] = [:]
    private var parameters: [String: Any] = [:]
    private var encoding: HTTPContentType = .application_form_urlencoded
    private var method: HTTPRequestMethod = .GET
    
    private init(host: URL) {
        self.host = host
    }
    
    class func request(host: URL) -> HTTPAPIRequest {
        return HTTPAPIRequest.init(host: host)
    }
    
    func setPath(_ path: URL) -> HTTPAPIRequest {
        self.path = path
        return self
    }
    
    func setHTTPHeaders(_ headers: [String : String]) -> HTTPAPIRequest {
        self.headers.merge(headers) { _, new  in new } // Latest values are kept
        return self
    }
    
    func setParameters(_ parameters: [String : Any]?) -> HTTPAPIRequest {
        if parameters != nil {
            self.parameters.merge(parameters!) { _, new  in new } // Latest values are kept
        }
        
        return self
    }
    
    func setHttpMethod(_ method: HTTPRequestMethod) -> HTTPAPIRequest {
        self.method = method
        return self
    }
    
    func setHttpEncoding(_ encoding: HTTPContentType) -> HTTPAPIRequest {
        self.encoding = encoding
        return self
    }
    
    func execute(uploadData: Data? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        
        var components = URLComponents(url: self.host, resolvingAgainstBaseURL: true)!
        components.path = components.path + self.path.absoluteString
        guard let url = components.url else {
            completion(nil, nil, nil)
            return nil
        }
        
        var request:URLRequest = URLRequest(url: url)
        
        // Content Type
        if (self.encoding == .application_form_urlencoded) {
            components.queryItems = self.parameters.map({ parameter in URLQueryItem(name: parameter.key, value: parameter.value as? String) })
            
            // URL for Get Request
            if self.method == .GET {
                request = URLRequest(url: components.url!)
            } else {
                request.httpBody = components.query?.data(using: .utf8)
            }
        } else if (self.encoding == .application_json) {
            if let theData = try? JSONSerialization.data(withJSONObject: self.parameters, options: []) {
                request.httpBody = theData
            }
        } else if (self.encoding == .multipart_form_data) {
            request.httpBody = uploadData
        }
        
        // HTTP Method
        request.httpMethod = method.rawValue
        
        // Content-Type
        request.setValue(self.encoding.rawValue, forHTTPHeaderField: "Content-Type")
        
        // HTTP Headers
        for header in self.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        // Set Timeout
        request.timeoutInterval = 15
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
        
        task.resume()
        return task
    }
    
}
