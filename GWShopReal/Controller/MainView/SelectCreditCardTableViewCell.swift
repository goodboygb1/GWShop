//
//  SelectCreditCardTableViewCell.swift
//  GWShopReal
//
//  Created by PMJs on 3/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class SelectCreditCardTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var cardNumber: UILabel!
    
    @IBOutlet weak var holderNumber: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    
}
