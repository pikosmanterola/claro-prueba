//
//  DetailRecipeViewController.swift
//  ejercicioClaro
//
//  Created by Tech Rojo on 7/14/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RealmSwift
import ObjectMapper

class DetailRecipeViewController: ExtentionsView, WKNavigationDelegate {
    
    var detailObject: NSDictionary?
    
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var titleRecipe: UILabel!
    @IBOutlet weak var ingredientsRecipe: UITextView!
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.titleRecipe.text = detailObject!["title"] as? String
        self.ingredientsRecipe.text = detailObject!["ingredients"] as? String
        let imageData = detailObject!["thumbnail"] as? NSData
        self.imageRecipe.image = UIImage(data: imageData! as Data)
    }
    
}
