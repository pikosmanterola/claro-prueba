//
//  RecipeResultsTableViewCell.swift
//  ejercicioClaro
//
//  Created by David Manterola on 7/13/19.
//  Copyright © 2019 Ejercicio Claro. All rights reserved.
//

import Foundation
import UIKit

class RecipeResultsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var titlerRecipe: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsRecipe: UITextView!
    @IBOutlet weak var urlRecipe: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
