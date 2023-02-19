//
//  WebManager.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 20.02.2023.
//

import Foundation
import Alamofire

class WebManager {
    static var shared = WebManager()
    private init() {}
    
    func makeRequest<T:Codable>(endpoint:Endpoint,Type:T.Type,completion: @escaping (DataResponse<T,AFError>) -> Void) {
        
        AF.request(endpoint.url, method: endpoint.httpMethod, parameters: endpoint.parameters,encoder: endpoint.encoder ?? JSONParameterEncoder.default, headers: endpoint.headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response)
            }
    }
}

