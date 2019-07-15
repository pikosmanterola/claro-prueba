//
//  ViewController.swift
//  ejercicioClaro
//
//  Created by David Manterola on 7/12/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class ViewController: ExtentionsView, UITextFieldDelegate {

    @IBOutlet weak var ingredients: UITextField!
    
    var recipeText: String = ""
    var ingredientsText: String = ""
    var page: Int = 1
    
    @IBAction func editEndIngredients(_ sender: Any) {
        
        if self.ingredients.text != nil && self.ingredients.text != "" {
            let question = self.ingredients.text!
            
            var fullTermArr = question.components(separatedBy: ": ")
            let racipeTerm: String = fullTermArr[0]
            var ingredientsTerms: String = ""
            if(fullTermArr.count > 1){
                ingredientsTerms = fullTermArr[1]
            }else{
                ingredientsTerms = ""
            }
           
            self.recipeText = racipeTerm
            self.ingredientsText = ingredientsTerms
            
        }else{
            let message: String = "The search field is required"
            showAlertMessage(message: message)
        }
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        view.endEditing(true)
        self.addLoarderView()
        
        let dictionary: [String : Any] = [
            "i": self.ingredientsText,
            "q": self.recipeText,
            "p": self.page
            ]
        var theJSONText: String?
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
        }
        
        if let user = Search(JSONString: theJSONText!) {
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(user, update: .all)
            }
            
            self.loarderView?.removeFromSuperview()
            self.performSegue(withIdentifier: "resultRecipes", sender: self)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.ingredients.delegate = self
        
    }


}

