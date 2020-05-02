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
        //static let profileToNewVendorSegue = "profileGoToNewVendor"
        //static let newVendorToStoreDetailSegue = "newVendotGoToStoreDetail"
        //static let profileToStoreDetailSegue = "profileGoToStoreDetail"
        static let storeDetialToEditAccountSegue = "storeDetailGoToEditAccount"
        static let storeDetailToEditStoreDetailSegue = "storeDetialGoToEditStoreDetail"
        static let storeDetailToWithdrawPageSegue = "storeDetailGoToWithDraw"
        static let storeMainToProductDetailSegue = "storeMainGoToProductDetail"
        static let meToMainStore = "meToMainStore"
        static let mainStoreToAddProduct = "mainStoreToAddProduct"
        static let meToCreateStore = "meToCreateStore"
        static let createStoreToMainStoreSegue = "createStoreToMainStoreSegue"
        static let mainStoreToStoreDetailSegue = "mainStoreToStoreDetail"
        static let productDetailToEditProductSegue = "productDetailToEditProduct"
        static let mainToSearchDetail = "mainToSearchDetail"
        static let promotionToAddPromotionSegue = "promotionToAddPromotion"
        static let addProductPromotionToAddPromotionSegue = "addProductPromotionToAddPromotion"
        static let searchToProductDetail = "searchToProductDetail"
        static let categoryProductToProductDetailsegue = "categoryProductToProductDetail"
        static let mainToCategoryProduct = "mainToCategoryProduct"
        static let searchToCartSegue = "searchToCart"
        static let mainToCartSegue = "mainToCart"
        static let categoryToCartSegue = "categoryToCart"
    }
    
    struct identifierForTableView{
        static let identifierAddress = "ReuseAddressCell"
        static let nibNameAddress = "AddressTableViewCell"
        static let identifierCard = "CardDetailIdentifier"
        static let identifierBankAccount = "BankAccountIdentifier"
        static let identifierBankAccountWithDraw = "accountForWithdrawIdentifier"
        static let identifierProductInStoreMain = "StoreMainProductIdentifier"
        static let addProductInAddPromotionCell = "addProductInAddPromotionCell"
        static let identifierPromotionInProductDetailCell = "promotionInProductDetailIdentifier"
        static let identifierpromotionInEditProduct = "promotionInEditProductIdentifier"
        static let identifierpromotionInPromotionPage = "promotionInPromotionPageIdentifier"
        static let searchCell = "searchCell"
        static let categoryCellIdentifier = "categoryCellIdentifier"
        static let promotionMainIdentifier = "promotionMainIdentifier"
        static let cartViewIdentifier = "cartViewIdentifier"
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
        static let transactionTableName = "transaction"
        static let promotionTableName = "promotion"
        static let hasPromotionTableName = "hasPromotion"
        static let cartTableName = "cart"
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
        static let productCollection = "product"
        static let productName = "productName"
        static let productDetail = "productDetail"
        static let productCategory = "productCategory"
        static let productPrice = "productPrice"
        static let productQuantity = "productQuantity"
        static let productImageURL = "productImageURL"
        static let sender = "sender"
         static let storeName = "storeName"
    }
    struct transaction{
        static let amountMoney = "amountMoney"
        static let isApprove = "isApprove"
    }
    struct promotion{
        static let promotionName = "promotionName"
        static let promotionDetail = "promotionDetail"
        static let discountPercent = "discountPercent"
        static let minimumPrice = "minimumPrice"
        static let validDate = "validDate"
    }
    
    
    struct categoryList {
        static let womenFashion = "เสื้อผ้าแฟชั่นผู้หญิง"
         static let menFashion = "เสื้อผ้าแฟชั่นผู้ชาย"
         static let mobile = "มือถือและอุปกรณ์เสริม"
         static let footSup = "ผลิตภัณฑ์สุขภาพ"
         static let toy = "ของเล่นสินค้าแม่และเด็ก"
         static let indoorAccessory = "เครื่องใช้ภายในบ้าน"
         static let menShoes = "รองเท้าผู้ชาย"
         static let womenShoes = "รองเท้าผู้หญิง"
        static let bag = "กระเป๋า"
        static let cosmetic = "เครื่องสำอาง"
        static let computer = "คอมพิวเตอร์"
        static let camera = "กล้องและอุปกรณ์"
        static let jewelry = "เครื่องประดับ"
        static let sport = "กีฬาและอุปกรณ์"
        static let foodAndBev = "อาหารและเครื่องดื่ม"
        static let indoorEntertainment = "สื่อบันเทิงภายในบ้าน"
        static let electronic = "เครื่องใช้ไฟฟ้าในบ้าน"
        static let game = "เกมส์และอุปกรณ์เสริม"
        static let pet = "สัตว์เลี้ยง"
        static let car = "ยานยนต์"
        static let stationary = "เครื่องเขียน"
        static let ticket = "ตั๋วและบัตรกำนัน"
        static let others = "อื่นๆ"
        static let watchAndGlasses = "นาฬิกาและแว่นตา"

    }
    
    struct cartDetail{
        static let productDocID = "productID"
        static let user = "userEmail"
        static let promotionDocID = "promotionID"
        static let quantity = "quantity"
        
    }

}

