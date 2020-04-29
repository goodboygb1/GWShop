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
    
    struct segue{
        static let logoutToMainSegue = "logoutToMainSegue"
        static let goToProfileSegue = "goToProfile"
        static let goToEditProfileSegue = "goToEditProfile"
        static let goToShowAddressSegue = "goToShowAddress"
        static let goToEditAddressSegue = "goToEditAddress"
        static let profileToShowCardSegue = "profileGoToShowCard"
        static let showCardToEditCardSegue = "showCardGoToEditCard"
        static let profileToNewVendorSegue = "profileGoToNewVendor"
        static let newVendorToStoreDetailSegue = "newVendotGoToStoreDetail"
        static let profileToStoreDetailSegue = "profileGoToStoreDetail"
    }
    
    struct identifierForTableView{
        static let identifierAddress = "ReuseAddressCell"
        static let nibNameAddress = "AddressTableViewCell"
        static let identifierCard = "CardDetailIdentifier"
        static let identifierBankAccount = "BankAccountIdentifier"
    }
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
        static let bankAccountTableName = "bankAccount"
    }
    
    struct storeDetail {
        static let storeName = "storeName"
        static let moneyTotal = "moneyTotal"
        static let addressDetail = "addressDetail"
        static let district = "storeDistrict"
        static let province = "storeProvince"
        static let postCode = "storePostCode"
    }
    
    struct bankAccount {
        static let bankName = "bankName"
        static let accountName = "accountName"
        static let accountNumber = "accountNumber"
        static let idCardNumber = "idCardNumber"
    }
    
    struct other {
        static  let empty = "empty"
    }
    
    struct productCollection {
        static let productCollection = "productCollection"
        static let productName = "productName"
        static let productDetail = "productDetail"
        static let productCategory = "productCategory"
        static let productPrice = "productPrice"
        static let productQuantity = "productQuantity"
        static let productImageURL = "productImageURL"
    }
    
}

