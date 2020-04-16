//
//  Repository.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/15.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

class Repository {
    
    var servive:NetworkServiceProtocol
    
    public init(service:NetworkServiceProtocol) {
        self.servive = service
    }
    
    func authenticate(email:String, password: String, completionHandler:@escaping ((APIAccessToken?, Error?) -> Void)) {
        
        struct LoginClient: NetworkClientProtocol, Encodable {
            let email: String
            let password: String
            
            func parameters() -> [String : Any]? {
                return LoginClient.encode(decoded: self) as? [String : Any]
            }
            
            func url() -> URL {
                return URL(string: "/api/users/login")!
            }
            
            func method() -> HTTPRequestMethod {
                return .POST
            }
            
            func encoding() -> HTTPContentType {
                return .application_json
            }
        }
        
        self.servive.execute(client: LoginClient(email:email, password: password)) { ( error, apiToken:APIAccessToken?) in
            completionHandler(apiToken, error)
        }
    }
    
    func regiter(user:[String:Any], completionHandler:@escaping ((Error?) -> Void)) {
        
        struct SignUpClient: NetworkClientProtocol {
            
            let user: [String:Any]
            
            func parameters() -> [String : Any]? {
                return self.user
            }
            
            func url() -> URL {
                return URL(string: "/api/users/register")!
            }
            
            func method() -> HTTPRequestMethod {
                return .POST
            }
            
            func encoding() -> HTTPContentType {
                return .application_json
            }
        }
        
        self.servive.execute(client: SignUpClient(user: user), responseHandler: { error, response in
            completionHandler(error)
            } as ((Error?, APIClientResponse?) -> Void))
    }
    
    func resetPasswordSend(email: String, completionHandler:@escaping ((Error?) -> Void)) {
        
        struct ResetPasswordClient: NetworkClientProtocol {
            
            let email: String
            
            func parameters() -> [String : Any]? {
                return [ "email" : self.email ]
            }
            
            func url() -> URL {
                return URL(string: "/api/users/reset")!
            }
            
            func method() -> HTTPRequestMethod {
                return .POST
            }
            
            func encoding() -> HTTPContentType {
                return .application_json
            }
        }
        
        self.servive.execute(client: ResetPasswordClient(email: email), responseHandler: { error, response in
            completionHandler(error)
            } as ((Error?, APIClientResponse?) -> Void))
    }
}
