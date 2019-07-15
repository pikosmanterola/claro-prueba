//
//  RecipeResultsViewController.swift
//  ejercicioClaro
//
//  Created by David Manterola on 7/13/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class RecipeResultsViewController: ExtentionsView, UIScrollViewDelegate{
    
    var feedArray : [NSDictionary] = []
    var recipeText: String = ""
    var ingredientsText: String = ""
    var page: Int = 1
    var image: NSData?
    var imageArray : [Int:NSData] = [:]
    
    var flagLoading : Int = 0
    var flagLoadMore : Int = 0
    let cellBuffer: CGFloat = 2
    let cellHeight: CGFloat = 468.0
    var scrollOffset : CGFloat = 0
    var totalItemsCount : Int = 0
    
    @IBOutlet weak var recipesTable: UITableView!{
        didSet {
            recipesTable.dataSource = self
            recipesTable.delegate = self
            //recipesTable.separatorStyle = .none
        }
    }
    
    let services = Services()
    
    @IBAction func backAction(_ sender: Any) {
        
        let dictionary: [String : Any] = [
            "i": "",
            "q": "",
            "p": 1
        ]
        var theJSONText: String?
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            theJSONText = String(data: theJSONData, encoding: .ascii)
        }
        
        if let user = Search(JSONString: theJSONText!) {
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(user, update: .all)
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getSearchObj{genres in
            self.addLoarderView()
            if genres{
                self.loadRecipes()
            }
            
        }
    }
    
    func loadRecipes() {
        
        services.getRecipes(ingredients: self.ingredientsText, recipe: self.recipeText, page: self.page) { success, object in
            if success {
                
                if let objResponse = object as? NSDictionary {
                    
                    let itemsResult = objResponse["results"] as! NSArray
                    
                    for (index, element) in itemsResult.enumerated(){
                        let entity = element as! NSDictionary
                        
                        let title = entity["title"] as? String
                        let link = entity["href"] as? String
                        let ingredients = entity["ingredients"] as? String
                        
                        var fullUrlArr = link!.components(separatedBy: "/")
                        let urlTerm: String = fullUrlArr[2]
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            
                            let urlStringThumb = entity["thumbnail"] as? String
                            let urlThumb = NSURL(string: urlStringThumb!)
                            let data = NSData(contentsOf: urlThumb! as URL)
                            
                            if data != nil {
                                self.image = data
                            }else{
                                let imageLocal = UIImage(named: "NoImageDefault")
                                let dataLocalImage = imageLocal?.pngData()
                                self.image = dataLocalImage as NSData?
                            }
                            
                            let arrayImage = self.image!
                            self.imageArray[index] = arrayImage
                            
                            DispatchQueue.main.async {
                                
                                self.recipesTable.reloadData()
                                
                            }
                            
                        }
                        
                        let arrayElement: NSDictionary = [
                            "title" : title as Any,
                            "link" : link as Any,
                            "ingredients" : ingredients as Any,
                            "url" : urlTerm as Any
                        ]
                        
                        self.flagLoading = 0
                        
                        if self.feedArray.count > self.totalItemsCount {
                            self.totalItemsCount = self.feedArray.count
                            self.flagLoadMore = 1
                        } else {
                            self.flagLoadMore = 0
                        }
                        
                        self.feedArray.append(arrayElement)
                        self.loarderView?.removeFromSuperview()
                        self.recipesTable.reloadData()
                        
                    }
                }
            } else {
                
            }
        }
        
    }
    
    func getSearchObj(completionHandler: @escaping (_ genres: Bool) -> ()) {
        
        let realm = try! Realm()
        let termsObj = realm.objects(Search.self).first
        
        self.recipeText = termsObj!["q"] as! String
        self.ingredientsText = termsObj!["i"] as! String
        self.page = termsObj!["p"] as! Int
        
        completionHandler(true)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "webViewSegue" {
            
            let destino = segue.destination as! UrlRecipeViewController
            if let cell = (sender as AnyObject).superview??.superview as? UITableViewCell {
                let indexPath = recipesTable.indexPath(for: cell)
                
                let url = feedArray[(indexPath?.row)!]
                let urlString = url["link"] as! String
                destino.urlWeb = urlString
            }
            
            
        }else if segue.identifier == "detailSegue"{
            
            if let cell = (sender as AnyObject) as? UITableViewCell {
                let indexPath = recipesTable.indexPath(for: cell)
                let obj = feedArray[(indexPath?.row)!]
                let objImage = imageArray[(indexPath?.row)!]
                
                let dictionary: [String : Any] = [
                    "title": obj["title"] as! String,
                    "ingredients": obj["ingredients"] as! String,
                    "link": obj["link"] as! String,
                    "thumbnail": objImage as Any
                ]
                
                let destino = segue.destination as! DetailRecipeViewController
                destino.detailObject = dictionary as NSDictionary
                
            }
            
            
        }
    }
}

extension RecipeResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.feedArray.count > 0){
            return self.feedArray.count
        }else{
            return 0
        }
        
    }
    
    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipesCell", for: indexPath) as! RecipeResultsTableViewCell
        cell.contentView.backgroundColor = UIColor.white
        let row = indexPath.row
        
        if (self.imageArray.count > 0 && self.imageArray.count == self.feedArray.count){
            
            let dataThumb = self.imageArray[row]
            cell.imageRecipe.image = UIImage(data: dataThumb! as Data)
            
            
        }
        
        cell.titlerRecipe.text = self.feedArray[row]["title"] as? String
        cell.ingredientsRecipe.text = self.feedArray[row]["ingredients"] as? String
        let titleRecipe = self.feedArray[row]["url"] as? String
        cell.urlRecipe.setTitle(titleRecipe, for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == recipesTable {
            
            scrollOffset = scrollView.contentOffset.y
            
            if self.flagLoading == 1 || self.flagLoadMore == 0 {
                return
            }
            
            let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
            let buffer: CGFloat = self.cellBuffer * self.cellHeight
            let scrollPosition = scrollView.contentOffset.y
            
            // Reached the bottom of the list
            if scrollPosition > bottom - buffer {
                // Add more dates to the bottom
                
                let page = self.page + 1
                self.flagLoading = 1
                self.page = page
                
                self.loadRecipes()
            }
        }
    }
    
}

