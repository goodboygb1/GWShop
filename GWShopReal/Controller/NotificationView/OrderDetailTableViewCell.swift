//
//  OrderDetailTableViewCell.swift
//  GWShopReal
//
//  Created by PMJs on 5/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
}
