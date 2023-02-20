//
//  OauthManager.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 20.02.2023.
//

import Foundation
import Alamofire


struct LoginResponse: Codable {
    var oauth: Oauth
}

struct Oauth: Codable {
    var access_token: String
    var expires_in: Int
}

class OauthManager {
    
    static var shared = OauthManager()
    
    private init() {}
    
    func isTokenValid(completion: @escaping (String) -> Void) {
        
        if let expireDate = UserDefaults.standard.object(forKey: "expire") as? Date {
            if Date() < expireDate {
                completion(getCurrentToken())
            } else {
                refreshToken { newToken in
                    completion(newToken)
                }
            }
        }else {
            refreshToken { newToken in
                completion(newToken)
            }
        }
    }
    
    private func getCurrentToken() -> String {
        
        if let currentToken = UserDefaults.standard.object(forKey: "token") as? String {
            return currentToken
        }
        return ""
    }
    
    private func refreshToken(completion: @escaping (String) -> Void)  {
        
        WebManager.shared.makeRequest(endpoint: EndpointCases.getToken, Type: LoginResponse.self) { response in
            
            switch response.result {
            case .success(let oauthResponse):
                completion(oauthResponse.oauth.access_token)
                
                UserDefaults.standard.set(oauthResponse.oauth.access_token, forKey: "token")
                UserDefaults.standard.set(Date().addingTimeInterval(1200), forKey: "expire")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


