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
}

class OauthManager {
    
    static var shared = OauthManager()
    
    private init() {}
    
    func isTokenValid(completion: @escaping (String) -> Void) {
        
        let currentToken = getCurrentToken()
        
        WebManager.shared.makeRequest(endpoint: EndpointCases.getTask(token: currentToken), Type: LoginResponse.self) { response in
            if response.response?.statusCode == 200 {
                completion(currentToken)
            }else if response.response?.statusCode == 401 {
                self.refreshToken { newToken in
                    completion(newToken)
                }
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
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


