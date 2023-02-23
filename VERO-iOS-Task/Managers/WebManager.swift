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
    
    private let oauthManager = OauthManager()
    
    //Generic request call
    func makeRequest<T:Codable>(endpoint:Endpoint,Type:T.Type,completion: @escaping (DataResponse<T,AFError>) -> Void) {
        
        AF.request(endpoint.url,
                   method: endpoint.httpMethod,
                   parameters: endpoint.parameters,
                   encoder: endpoint.encoder ?? JSONParameterEncoder.default,
                   headers: endpoint.headers)
        .validate()
        .responseDecodable(of: T.self) { response in
            completion(response)
        }
    }
    //Getting data from server
    func fetchData(completion: @escaping (Result<[Task],Error>) -> Void ) {
        
        oauthManager.isTokenValid { result in
            
            switch result {
            case .success(let token):
                
                self.makeRequest(endpoint: EndpointCases.getTask(token: token), Type: [Task].self) { response in
                    
                    switch response.result {
                        
                    case .success(let workers):
                        completion(.success(workers))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

