//
//  RequestConfiguration.swift
//  ejercicioClaro
//
//  Created by David Manterola on 7/13/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import Foundation
import Moya
import RealmSwift

enum RecipeRequest {
    case getRecipesByIngredients(i:String, q:String, p: Int)
}

extension RecipeRequest: TargetType {
    var baseURL: URL { return URL(string: Constants.baseURL)! }
    
    var path: String {
        switch self {
        case .getRecipesByIngredients(let i, let q, let p):
            return "?i=\(i)&q=\(q)&p=\(p)"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getRecipesByIngredients:
            return ["Content-Type":"application/json"]
        default:
            return ["Content-Type":"application/json"]
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecipesByIngredients:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        /*var token: String = ""
        let realm = try! Realm()
        let userResponse = realm.objects(UserResponse.self)*/
        
        switch self {
        case .getRecipesByIngredients(let i, let q, let p):
            return .requestParameters(parameters: ["i":i,"q":q,"p":p], encoding: JSONEncoding.default)
        }
    }
}
