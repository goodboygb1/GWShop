//
//  categoryCell.swift
//  GWShopReal
//
//  Created by PMJs on 1/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class categoryCell: UITableViewCell {

    
    @IBOutlet weak var productNameLable: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var storeNameLable: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    var productImageURL : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
