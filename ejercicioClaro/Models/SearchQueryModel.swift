//
//  SearchQueryModel.swift
//  ejercicioClaro
//
//  Created by David Manterola on 7/13/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Search: Object, Mappable {
    @objc dynamic var id: Int = 0
    @objc dynamic var i: String = ""
    @objc dynamic var q: String = ""
    @objc dynamic var p: Int = 1
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.i <- map["i"]
        self.q <- map["q"]
        self.p <- map["p"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
