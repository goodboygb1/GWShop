//
//  ProductTableViewCell.swift
//  GWShopReal
//
//  Created by PMJs on 3/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var priceForEach: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var totalPriceForEach: UILabel!
    
}
