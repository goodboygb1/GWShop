//
//  Cart.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 2/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import Foundation

struct Cart{
    let storeName: String
    let productName: String
    let productPrice: String
    let numberProduct: Int
    let documentID: String
    let productDocumentID: String
    var realPrice: Double 
    let imageURL : String
    
    mutating func changeRealPrice(realPrice: Double){
        self.realPrice = realPrice
    }
}
