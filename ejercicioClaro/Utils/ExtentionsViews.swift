//
//  ExtentionsViews.swift
//  ejercicioClaro
//
//  Created by David Manterola on 7/14/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import Foundation
import UIKit

class ExtentionsView: UIViewController {
    
    var loarderView: UIView?
    
    func addLoarderView() {
        
        let bounds: CGRect = UIScreen.main.bounds
        let height = bounds.size.height
        let width =  bounds.size.width
        
        loarderView =  UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        loarderView?.backgroundColor = UIColor.white
        loarderView?.alpha =  0.7
        loarderView?.tag = 1000
        
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activity.center =  view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        
        loarderView?.addSubview(activity)
        self.view.addSubview(loarderView!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlertMessage(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Aceptar", style: .default){ (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    var placeholderColor: UIColor = .lightGray
    
    override var placeholder: String? {
        didSet {
            let attributes = [ NSAttributedString.Key.foregroundColor: placeholderColor ]
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        }
    }
}
