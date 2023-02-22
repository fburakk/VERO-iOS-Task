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
    
    //Generic request call
    func makeRequest<T:Codable>(endpoint:Endpoint,Type:T.Type,completion: @escaping (DataResponse<T,AFError>) -> Void) {
        
        AF.request(endpoint.url, method: endpoint.httpMethod, parameters: endpoint.parameters,encoder: endpoint.encoder ?? JSONParameterEncoder.default, headers: endpoint.headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response)
            }
    }
    //Getting data from server
    func fetchData(onSucces: @escaping ([Task]) -> Void, onFailure: @escaping (String) -> Void) {
        OauthManager.shared.isTokenValid { token in
            print(token)
            
            self.makeRequest(endpoint: EndpointCases.getTask(token: token), Type: [Task].self) { response in
                
                switch response.result {
                case .success(let workers):
                    onSucces(workers)
                case .failure(let error):
                    onFailure(error.localizedDescription)
                }
            }
        }
    }
}

