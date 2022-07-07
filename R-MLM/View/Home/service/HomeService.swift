//
//  HomeService.swift
//  R-MLM
//
//  Created by GTMAC15 on 1.07.2022.
//

import Foundation


import Foundation

protocol IHomeService {
    func fetchData(completion: @escaping (_ success: Bool, _ results: MLMResponse?, _ error: String?) -> ())
}

class HomeService: IHomeService {
    func fetchData(completion: @escaping (Bool, MLMResponse?, String?) -> ()) {
        NetworkService().request(url: ServiceEndPoint.urlPath(),method: HTTPMethod.GET, params: ["": ""], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(MLMResponse.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse MLMResponse to model")
                }
            } else {
                completion(false, nil, "Error: MLMResponse GET Request failed")
            }
        }
    }
}


