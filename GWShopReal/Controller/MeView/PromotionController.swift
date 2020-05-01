//
//  PromotionController.swift
//  GWShopReal
//
//  Created by PMJs on 30/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
class PromotionController: UIViewController {

    @IBOutlet weak var promotionTableView: UITableView!
    var db = Firestore.firestore()
    var promotions: [Promotion] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        promotionTableView.dataSource = self
        loadPromotionData()
    }
    
    func loadPromotionData(){
        if let emailSender = Auth.auth().currentUser?.email{
            self.promotions = []
            db.collection(K.tableName.promotionTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error while loading promotion data in promotion page: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        for doc in snapShotDocuments{
                            let data = doc.data()
                            let docID = doc.documentID
                            if let promotionName = data[K.promotion.promotionName] as? String, let promotionDetail = data[K.promotion.promotionDetail] as? String,
                            let discountPercent = data[K.promotion.discountPercent] as? Int, let minimumPrice = data[K.promotion.minimumPrice] as? String,
                            let validDate = data[K.promotion.validDate] as? String{
                                self.promotions.append(Promotion(promotionName: promotionName, promotionDetail: promotionDetail, minimumPrice: minimumPrice, discountPercent: discountPercent, validDate: validDate, docID: docID))
                                DispatchQueue.main.async {
                                    self.promotionTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addPromotionPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.promotionToAddPromotionSegue, sender: self)
    }
}

extension PromotionController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let promotion = promotions[indexPath.row]
        let promotionCell = promotionTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.identifierpromotionInPromotionPage) as! promotionCellinPromotionPage
        promotionCell.promotionNameText.text = promotion.promotionName
        promotionCell.promotionDetailText.text = promotion.promotionDetail
        promotionCell.minimumPriceText.text = promotion.minimumPrice
        promotionCell.discountPercentText.text = String( promotion.discountPercent)
        promotionCell.validDateText.text = promotion.validDate
        
        return promotionCell
    }

}

class promotionCellinPromotionPage: UITableViewCell {
    @IBOutlet weak var promotionNameText: UILabel!
    @IBOutlet weak var promotionDetailText: UILabel!
    @IBOutlet weak var minimumPriceText: UILabel!
    @IBOutlet weak var discountPercentText: UILabel!
    @IBOutlet weak var validDateText: UILabel!
}
