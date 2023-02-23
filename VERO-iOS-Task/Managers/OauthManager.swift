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
    
    //Getting previous token if its valid otherwise getting new token
    func isTokenValid(completion: @escaping (Result<String,Error>) -> Void) {
        
        if let expireDate = UserDefaults.standard.object(forKey: "expire") as? Date {
            if Date() < expireDate {
                completion(.success(getCurrentToken()))
            } else {
                refreshToken(completion: completion)
            }
        }else {
            refreshToken(completion: completion)
        }
    }
    //Getting previous token from UserDefaults
    private func getCurrentToken() -> String {
        
        if let currentToken = UserDefaults.standard.object(forKey: "token") as? String {
            return currentToken
        }
        return ""
    }
    //Getting new token and save it to UserDefaults
    private func refreshToken(completion: @escaping (Result<String,Error>) -> Void)  {
        
        WebManager.shared.makeRequest(endpoint: EndpointCases.getToken, Type: LoginResponse.self) { response in
            
            switch response.result {
            case .success(let oauthResponse):
                completion(.success(oauthResponse.oauth.access_token))
                
                UserDefaults.standard.set(oauthResponse.oauth.access_token, forKey: "token")
                UserDefaults.standard.set(Date().addingTimeInterval(1200), forKey: "expire")
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


