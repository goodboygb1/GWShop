//
//  addProductInAddPromotionCell.swift
//  GWShopReal
//
//  Created by PMJs on 30/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class addProductInAddPromotionCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productNameLable: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var productImageURL : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
