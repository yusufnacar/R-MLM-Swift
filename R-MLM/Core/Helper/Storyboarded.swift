//
//  Storyboarded.swift
//  R-MLM
//
//  Created by GTMAC15 on 1.07.2022.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // pulls "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // give that "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]
        
        // load storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

