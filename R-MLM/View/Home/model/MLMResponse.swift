//
//  MLMResponse.swift
//  R-MLM
//
//  Created by GTMAC15 on 1.07.2022.
//

import Foundation
import RealmSwift
import UIKit
class MLMResponseElement: Object, Codable  {
    
    @objc dynamic var name : String = ""
    @objc dynamic var surname: String = ""
    var shots = List<Shot>()
}

// MARK: - Shot
class Shot: Object ,Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var point : Int = 0
    @objc dynamic var segment: Int = 0
    @objc dynamic var inOut: Bool = false
    @objc dynamic var  shotPosX : Double = 0.0
                      
    @objc dynamic var shotPosY: Double = 0.0
    @objc dynamic var videoUrl: String = ""
//    @objc dynamic var videoUrl: URL?


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case point, segment
        case inOut = "InOut"
        case shotPosX = "ShotPosX"
        case shotPosY = "ShotPosY"
    }
}

typealias MLMResponse = [MLMResponseElement]



class RealmHelper {
    static func saveObject<T:Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    static func getObjects<T:Object>()->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self)
        return Array(realmResults)

    }
    static func getObjects<T:Object>(filter:String)->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self).filter(filter)
        return Array(realmResults)

    }
}
