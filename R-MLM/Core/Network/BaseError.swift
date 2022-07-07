//
//  BaseError.swift
//  R-MLM
//
//  Created by GTMAC15 on 30.06.2022.
//

import Foundation


struct BaseError {
    var errorMessage: String
    
    init(_ error : String?) {
        errorMessage = error ?? ""
    }
}
