//
//  URLManager.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 20.02.2023.
//

import Foundation
import Alamofire

//URL Endpoint protocol
protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: [String: String]? { get }
    var encoder: ParameterEncoder? { get }
}

//Extension for fully url
extension Endpoint {
    var url: String {
        return baseURLString + path
    }
}

//Cases for different URLs
enum EndpointCases: Endpoint {
    case getToken
    case getTask(token:String)
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .getToken:
            return .post
        case .getTask:
            return .get
        }
    }
    
    var baseURLString: String {
        switch self {
        case .getToken:
            return "https://api.baubuddy.de/"
        case .getTask:
            return "https://api.baubuddy.de/"
        }
    }
    
    var path: String {
        switch self {
        case .getToken:
            return "index.php/login"
        case .getTask:
            return "dev/index.php/v1/tasks/select"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .getToken:
            return [
                "username" : "365",
                "password" : "1"
            ]
        case .getTask:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getToken:
            return [
                "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
                "Content-Type": "application/json"
            ]
        case .getTask(let token):
            return [.authorization(bearerToken: token)]
        }
    }
    
    var encoder: ParameterEncoder? {
        switch self {
        case .getToken:
            return JSONParameterEncoder.default
        case .getTask:
            return nil
        }
    }
}




