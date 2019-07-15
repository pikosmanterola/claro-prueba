//
//  Recipes.swift
//  ejercicioClaro
//
//  Created by David Manterola on 7/14/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Recipes: Object, Mappable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var ingredients: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var thumbnail: NSData?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        ingredients <- map["ingredients"]
        link <- map["link"]
        thumbnail <- map["thumbnail"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
