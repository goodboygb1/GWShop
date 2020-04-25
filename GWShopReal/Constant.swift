//
//  Constant.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import Foundation

struct segue {
    static var loginToMain = "loginToMain"
    static let registerToMain = "registerToMain"
}


struct K {
    static let maleGender = "Male"
    static let femaleGender = "Female"
    static let otherGender = "Other"
    
    static let firstName = "firstName"
    static let surname = "surname"
    static let gender = "gender"
    static let phoneNumber = "phoneNumber"
    static let dateOfBirth = "dateOfBirth"
    static let addressDetail = "addressDetail"
    static let province = "province"
    static let district = "district"
    static let postCode = "postCode"
    static let userDetailCollection = "userDetail"
    
    static let dateField = "date"
    static let sender = "sender"
    
    struct cardDetail{
        static let cardNumber = "cardNumber"
        static let cardName = "nameCardHolder"
        static let cvvNumber = "cvv"
        static let expiredDate = "expiredDate"
    }
    
    struct tableName {
        static let addressTableName = "address"
        static let cardDetailTableName = "cardDetail"
        static let storeDetailTableName = "vendor"
    }
    
    struct storeDetail {
        static let storeName = "storeName"
        static let moneyTotal = "moneyTotal"
    }
}

