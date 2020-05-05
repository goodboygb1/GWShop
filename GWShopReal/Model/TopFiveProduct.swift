//
//  TopFiveProduct.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 4/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import Foundation

struct TopFiveProduct {
    let productID: String
    let productName: String
    let storeName: String
    var sold: Int 
    
    mutating func AddSold(number: Int){
        self.sold = self.sold + number
    }
}
