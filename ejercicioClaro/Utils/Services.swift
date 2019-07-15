//
//  Services.swift
//  ejercicioClaro
//
//  Created by David Manterola on 7/13/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import Foundation
import Moya
import RealmSwift
import ObjectMapper

class Services {
    
    private let provider = MoyaProvider<RecipeRequest>()
    
    func getRecipes( ingredients:String, recipe:String, page: Int, _ completion: @escaping(_ success: Bool, _ object: Any?) -> Void) {
        provider.request(.getRecipesByIngredients(i: ingredients, q: recipe, p: page)) { result in
            switch result {
            case .success(let response):
                guard let jsonString = try? response.mapString() else {
                    return completion(false, nil)
                }
                
                let recipes = self.convertToDictionary(text: jsonString)
                completion(true, recipes)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
