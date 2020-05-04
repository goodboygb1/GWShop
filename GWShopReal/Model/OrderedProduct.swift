//
//  OrderedProduct.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 4/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import Foundation

struct OrderedProduct {
    let orderID: String
    let addressID: String
    let datePurchased: String
    let orderStatus: Bool
    let paymentID: String
    let total: Double
    let orderDocID: String
    let user: String
}

struct OrderedProductDetail {
    let quantity: Int
    let productID: String
    let productName: String
    let imageURL:String
    let totalPrice: Double
}
