//
//  APIClientProtocol
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

enum HTTPRequestMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

enum HTTPResponseStatusCode: Int {
    case information
    case success
    case redirection
    case client_error
    case server_error
    case invalid
    
    init(statusCode: Int) {
        if (100..<200).contains(statusCode) { self = .information }
        else if (200..<300).contains(statusCode) { self = .success }
        else if (300..<400).contains(statusCode) { self = .redirection }
        else if (400..<500).contains(statusCode) { self = .client_error }
        else if (500..<600).contains(statusCode) { self = .server_error }
        else { self = .invalid }
    }
    
    func description() -> String {
        switch self {
        case .information : return "1xx Informational"
        case .success : return "2xx Success"
        case .redirection : return "3xx Redirection"
        case .client_error : return "4xx Client Error"
        case .server_error : return "5xx Server Error"
        case .invalid : return "xxx Invalid or Unkown Error"
        }
    }
}

enum HTTPContentType: String {
    case application_json = "application/json"
    case application_form_urlencoded = "application/x-www-form-urlencoded"
    case multipart_form_data = "multipart/form-data"
    case none = ""
}

enum HTTPAcceptType: String {
    case application_json = "application/json"
    case application_xml = "application/xml"
    case text_plain = "text/plain"
}

protocol APIClientProtocol {
    func url() -> URL
    func parameters() -> [String : Any]?
    func extraHeaders() -> [String : String]?
    func method() -> HTTPRequestMethod
    func encoding() -> HTTPContentType
    func acceptType() -> HTTPAcceptType
    
}

extension APIClientProtocol {
    
    func parameters() -> [String : Any]? {
        return nil
    }
    
    func encoding() -> HTTPContentType {
        return .application_form_urlencoded
    }
    
    func acceptType() -> HTTPAcceptType {
        return .application_json
    }
    
    func extraHeaders() -> [String : String]? {
        return nil
    }
    
}
