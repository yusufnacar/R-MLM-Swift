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
//    case BASE_URL = "https://f3da13ed-a839-4dae-a916-57445ead60cb.mock.pstmn.io"
//    case PATH = "/rapsodomock"
//https://f3da13ed-a839-4dae-a916-57445ead60cb.mock.pstmn.io/rapsodomock
    static func urlPath() -> String {
        return "\(BASE_URL.rawValue)\(PATH.rawValue)"
    }
}
