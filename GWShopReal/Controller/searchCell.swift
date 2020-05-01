//
//  searchResultCell.swift
//  GWShopReal
//
//  Created by PMJs on 1/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class searchCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultNameLabel: UILabel!
    @IBOutlet weak var resultPriceLabel: UILabel!
    var resultImageURL : String?
    var resultProductID : String?        // prodcutID = DocumentID
    var senderName : String?             // collect senderName
    
}
