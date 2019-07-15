//
//  UrlRecipeViewController.swift
//  ejercicioClaro
//
//  Created by Tech Rojo on 7/14/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class UrlRecipeViewController: ExtentionsView, WKNavigationDelegate {
    
    var urlWeb:String = ""
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBOutlet weak var webViewDetail: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: urlWeb)!
        let requestObj = URLRequest(url: url)
        self.webViewDetail.load(requestObj)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

