//
//  EndpointUrlEnum.swift
//  R-MLM
//
//  Created by GTMAC15 on 7.07.2022.
//

import Foundation


enum ServiceEndPoint: String {
    case BASE_URL = "https://interview-2dlcobr5jq-ue.a.run.app"
    case PATH = "/shots"
    static func urlPath() -> String {
        return "\(BASE_URL.rawValue)\(PATH.rawValue)"
    }
}
