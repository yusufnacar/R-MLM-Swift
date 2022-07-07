//
//  NetworkHelper.swift
//  R-MLM
//
//  Created by GTMAC15 on 30.06.2022.
//

import Foundation


enum HTTPHeaderFields {
    case application_json
    case application_x_www_form_urlencoded
    case none
}





protocol INetworkService {
    func request(url: String , method: HTTPMethod,  params : [String : String] , httpHeader: HTTPHeaderFields , onSuccess: @escaping (Bool , Data?) -> Void )
}

class NetworkService : INetworkService{
    
    static let service = NetworkService()
    
    
    
    func request(url: String, method: HTTPMethod, params: [String : String], httpHeader: HTTPHeaderFields, onSuccess: @escaping (Bool , Data?) -> Void) {
        guard var components = URLComponents(string: url) else {
            print("Error: cannot create URLCompontents")
            return
        }
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = components.url else {
            print("Error : No URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch httpHeader {
        case .application_json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .application_x_www_form_urlencoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .none: break
        }
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                
                onSuccess(false,nil)
                return
            }
            guard let data = data else {
                
                onSuccess(false,nil)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                
                onSuccess(false,nil)
                return
            }
            onSuccess(true,data)
        }.resume()
    }
}










